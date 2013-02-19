Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab3BSSKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:10:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:34497 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab3BSSKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:10:11 -0500
Date: Tue, 19 Feb 2013 19:10:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>
Subject: Re: [resend] Timer broadcast question
In-Reply-To: <5123BE35.8070902@linaro.org>
Message-ID: <alpine.LFD.2.02.1302191904560.22263@ionos>
References: <5123BE35.8070902@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Daniel Lezcano wrote:
> I am working on identifying the different wakeup sources from the
> interrupts and I have a question regarding the timer broadcast.
> 
> The broadcast timer is setup to the next event and that will wake up any
> idle cpu belonging to the "broadcast cpumask", right ?
> 
> The cpu which has been woken up will look for each cpu the next-event
> and send an IPI to wake it up.
>  
> Although, it is possible the sender of this IPI may not be concerned by
> the timer expiration and has been woken up just for sending the IPI, right ?

Correct.
 
> If this is correct, is it possible to setup the timer irq affinity to a
> cpu which will be concerned by the timer expiration ? so we prevent an
> unnecessary wake up for a cpu.

It is possible, but we never implemented it.

If we go there, we want to make that conditional on a property flag,
because some interrupt controllers especially on x86 only allow to
move the affinity from interrupt context, which is pointless.

Thanks,

	tglx



