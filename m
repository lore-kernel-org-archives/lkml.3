Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaCaNLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:11:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:60229 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaCaNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:11:46 -0400
Date: Mon, 31 Mar 2014 15:11:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [Query]: hrtimer: Does switch_hrtimer_base() need to check
 hrtimer_check_target()?
In-Reply-To: <CAKohpo=L8ZiR67OR0Sz0LeGdRxn92rfbJbsHd-ybt==MwfQJ3Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403311507470.14882@ionos.tec.linutronix.de>
References: <CAKohpo=L8ZiR67OR0Sz0LeGdRxn92rfbJbsHd-ybt==MwfQJ3Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, Viresh Kumar wrote:

> Hi Thomas,
> 
> I couldn't understand one part of hrtimer (obviously there are
> others as well, but here I am sure I couldn't understood it :)).
> 
> In switch_hrtimer_base() we are calling hrtimer_check_target()
> which guarantees this:
> 
> /*
>  * With HIGHRES=y we do not migrate the timer when it is expiring
>  * before the next event on the target cpu because we cannot reprogram
>  * the target cpu hardware and we would cause it to fire late.
>  *
>  * Called with cpu_base->lock of target cpu held.
>  */
> 
> But switch_hrtimer_base() is only called from one place, i.e.
> __hrtimer_start_range_ns() and at the point (where we call
> switch_hrtimer_base()) expiration time is not yet known as
> we call this routine later:
> 
> hrtimer_set_expires_range_ns()
> 
> So, do we really need to call hrtimer_check_target() at all
> in switch_hrtimer_base()? Or do we need to move
> hrtimer_set_expires_range_ns() before calling
> switch_hrtimer_base() ??

Yes, we should move setting the expiry time before we call
switch_hrtimer_base().

Thanks,

	tglx
