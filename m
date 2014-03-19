Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaCSUcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:32:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:36582 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaCSUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:32:01 -0400
Date: Wed, 19 Mar 2014 21:32:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] timer: Make sure TIMER_FLAG_MASK bits are free in
 allocated base
In-Reply-To: <CAKohpo=g4nhRUN7wJY-fpE1TiQWEDExKpZ1p4C8gUEDK8mXZ_Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403192125260.18573@ionos.tec.linutronix.de>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org> <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1402281151180.18573@ionos.tec.linutronix.de>
 <CAKohpomHXLVKqzFCbp8qt7gGpdDkc-s5wASRvw1EBwuB_fpceA@mail.gmail.com> <CAKohpo=g4nhRUN7wJY-fpE1TiQWEDExKpZ1p4C8gUEDK8mXZ_Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Viresh Kumar wrote:
> On 11 March 2014 15:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >
> > Now, I was looking to migrate away the timers first but I
> > obviously shouldn't migrate the pinned timers. One way out to
> > identify PINNED timers is to mark them PINNED with the flag bits,
> > which you wouldn't allow. Can you give some other idea with which
> > I can get this solved.

Sigh, I really hoped to find some time to finish the rework, but then
you get to debug bugs, solve the problem and are rewarded with a full
inbox. Lather, rinse, repeat...

Go ahead and make the timer base aligned with more room for some bits
to tweak. The new stuff will have a flags field where stuff like
pinned is stored.

Thanks,

	tglx


