Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaARPV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 10:21:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaARPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 10:21:54 -0500
Message-ID: <1390058494.5439.3.camel@marge.simpson.net>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 18 Jan 2014 16:21:34 +0100
In-Reply-To: <20140118124451.GA30183@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
	 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	 <20140116222536.GX30183@twins.programming.kicks-ass.net>
	 <20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
	 <52D8625C.1000902@zytor.com>
	 <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
	 <1390038366.5676.10.camel@marge.simpson.net>
	 <20140118124451.GA30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/QStqaEeDJAZFj0/hiM2zEGFCgzSvtKyCH9NCOQ1fQ7
 1hshBCAe/w4inbPWqeD8ncGpJ7e81qjB8TrxoRDO3z7R0TAujq
 EWmH0B2c7CCMJHszpy1HW4NyXGR737CIM8irbmjzDZKS5lF48+
 AiQD8MrgSDrRwbaZmodP0sUvbcF0iU3dOq07RXjk+2nWREjSMM
 AVMUX5hqcmDtRXluipn2b0SIfz/LmYsfmFWsCgm5CE2tFBzMLi
 cWYJuTVmqMdQe8SSiWHJ+UrHsaLs1Sddzec365cXCd4lSiYWIH
 JA4a19WB3jo0h/wtophFdiQB/4vFIs9JtgZEi7oOIUctp2ySQf
 fjjSH1CtX6yD6Maa96YGZlp9qGm3JoUswvqHItYYUFqM9x+fXH
 oFAOVKmFtD1ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-18 at 13:44 +0100, Peter Zijlstra wrote: 
> On Sat, Jan 18, 2014 at 10:46:06AM +0100, Mike Galbraith wrote:
> > 
> > I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
> > Q6600 box.  See below for an alternative.
> 
> Urgh, I see, we call the idle arch_cpu_idle() callback with irqs
> disabled.
> 
> Could something like this work?
> 
> 	local_irq_enable();
> 	mwait_idle_with_hints(0,0);
> 
> The interrupt enable window is slightly larger, but I'm not immediately
> seeing a problem with that.

Yup, works just fine.  Less is more.

Nice to see a _progression_ in the pipe too btw.

-Mike

