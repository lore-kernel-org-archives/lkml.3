Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3KYJxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:53:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35451 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3KYJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:53:33 -0500
Date: Mon, 25 Nov 2013 10:53:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: fengguang.wu@intel.com, "Li, Shaohua" <shaohua.li@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: kernel BUG at drivers/md/raid5.c:693!
Message-ID: <20131125095323.GW10022@twins.programming.kicks-ass.net>
References: <20131123032205.GB20794@localhost>
 <20131125103522.6a1c1b36@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125103522.6a1c1b36@notabene.brown>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:35:22AM +1100, NeilBrown wrote:
> Ingo/Peter: is it considered OK to call wake_up while holding a spinlock?

Yes, very much so. Doing a wakeup isn't _that_ expensive.

> Could "sleeping spinlocks" affect this at all? (some sample stack traces are
> below).

Not entirely sure, are you referencing to -rt where me make spinlock_t
pi-mutexes?
