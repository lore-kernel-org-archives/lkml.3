Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab3FTJNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:13:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:59857 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965135Ab3FTJNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:13:41 -0400
Date: Thu, 20 Jun 2013 11:13:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: timer: looping issue, need reset variable
 'found'
In-Reply-To: <51C2BCB3.4060603@asianux.com>
Message-ID: <alpine.DEB.2.02.1306201029390.4013@ionos.tec.linutronix.de>
References: <51B4A408.4050909@asianux.com> <alpine.LFD.2.02.1306101501160.22970@ionos> <51C039A8.5000903@asianux.com> <alpine.DEB.2.02.1306200944530.4013@ionos.tec.linutronix.de> <51C2BCB3.4060603@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:
> On 06/20/2013 03:47 PM, Thomas Gleixner wrote:
> -------------------------------------------------------------------------------
> If we assume "If there is nothing in tv2 which might come before the
> found timer, then any timer in tv3 will ..." is correct.
> 
> When we found a timer in 'tv1', we will not search all timers in 'tv2'
> (we only search first looping of tv2 for the specific 'slot').

Yes, because that's how the timer wheel works. And I'm not going to
explain you every little detail of it.
 
> Is it still OK ?

Yes, it is. 

> If you do not want to discuss with others, better quite politely, not
> need judging or checking others, it is useless for the cooperation with
> each other, is it right ?  ;-)

I discussed all your patches which fall into my area of responsibility
with you and I explained to you very politely why your patches are
incorrect.

When I noticed, that you do not even understand how the timer wheel
works in detail, which is necessary to understand why the code in
__next_timer_interrupt() is correct, I asked you politely:

> > Then I recommend that you to sit down and analyze the correctness of
> > the code.

And you answered:

> That is only your recommend, not mean I have duty to.

Right, it's only a recommendation. Though without proof of a failure,
I'm not going to discuss that further and I'm not going to apply a
patch.

Thanks,

	tglx

