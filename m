Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaFNSsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 14:48:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFNSsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 14:48:11 -0400
Date: Sat, 14 Jun 2014 20:48:07 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v3] printk: allow increasing the ring buffer depending
	on the number of CPUs
Message-ID: <20140614184807.GE4841@wotan.suse.de>
References: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com> <1402695712.27369.10.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402695712.27369.10.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out we can't use num_possible_cpus() that early on boot, as
it hasn't yet been properly set, nor other helpers, a late setup for
big CPUs is therefore needed in order to use num_possible_cpus().
That also means we can use kzalloc() instead. I'll send a v4 and
I think we should test this a bit so will send as RFT.

  Luis
