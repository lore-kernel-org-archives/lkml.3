Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab3LLPwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:52:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39338 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LLPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:52:15 -0500
Date: Thu, 12 Dec 2013 16:51:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131212155153.GK13532@twins.programming.kicks-ass.net>
References: <1386764955.12005.60.camel@marge.simpson.net>
 <20131211124352.GB21999@twins.programming.kicks-ass.net>
 <20131211134048.GH21683@pd.tnic>
 <20131211145655.GB4510@gmail.com>
 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
 <20131211175036.GC12431@gmail.com>
 <52A8F073.9040500@zytor.com>
 <20131212085143.GC21999@twins.programming.kicks-ass.net>
 <20131212132846.GA16750@gmail.com>
 <52A9D111.3090409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A9D111.3090409@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 07:06:57AM -0800, H. Peter Anvin wrote:
> On 12/12/2013 05:28 AM, Ingo Molnar wrote:
> >>
> >> The reason we use thread_info::flags is because we need to write
> >> TIF_NEED_RESCHED into it to wake up anyhow.
> >>
> >> Using another cacheline would mean the wakeup path would need to write a
> >> second cross cpu cacheline -- that is badness too.
> >>
> >> So no, I don't think we want to listen to another line.
> > 
> 
> Right, okay, so that's the implicit wakeup.  However, I would think the
> CLFLUSH would hurt a lot more.

Maybe, but still, who cares? Its only a few broken cpus that actually
need the clflush, normal cpus do not. We should not optimize for the
broken case.


