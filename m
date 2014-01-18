Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaARMpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 07:45:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaARMpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 07:45:21 -0500
Date: Sat, 18 Jan 2014 13:44:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140118124451.GA30183@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
 <20140116222536.GX30183@twins.programming.kicks-ass.net>
 <20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
 <52D8625C.1000902@zytor.com>
 <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
 <1390038366.5676.10.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390038366.5676.10.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 10:46:06AM +0100, Mike Galbraith wrote:
> 
> I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
> Q6600 box.  See below for an alternative.

Urgh, I see, we call the idle arch_cpu_idle() callback with irqs
disabled.

Could something like this work?

	local_irq_enable();
	mwait_idle_with_hints(0,0);

The interrupt enable window is slightly larger, but I'm not immediately
seeing a problem with that.
