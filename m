Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaFGNeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 09:34:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaFGNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 09:34:08 -0400
Date: Sat, 7 Jun 2014 06:34:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Ken Helias <kenhelias@web.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 03/13] list: Add list_add_(before|after) macros
Message-ID: <20140607133400.GA13329@infradead.org>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
 <1402076072-4044-3-git-send-email-kenhelias@web.de>
 <alpine.LSU.2.11.1406061242370.16010@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406061242370.16010@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 12:51:35PM -0700, Hugh Dickins wrote:
> I'll express my opinion: perhaps it's widely shared, perhaps it is not.
> 
> I think a patch like this (and the subsequent conversions) is unhelpful
> churn.
> 
> The Linux struct list_head is designed and intended to be used for both
> head and entry, and introducing aliases to make unnecessary distinctions
> just hinders development instead of helping it.
> 
> If the reader is confused at first, I hope the reader will soon learn,
> without needing to rely on aliases such as these.

I fully concur with Hugh - the list_head is symmetric for heads vs
entires, and lots of code depends on that.

In addition to that multiple functions that do exactly the same thing
generall are a bad idea.

