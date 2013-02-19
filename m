Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab3BSSCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:02:34 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59150 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3BSSCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:02:33 -0500
Message-ID: <5123BE35.8070902@linaro.org>
Date: Tue, 19 Feb 2013 19:02:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>
Subject: [resend] Timer broadcast question
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am working on identifying the different wakeup sources from the
interrupts and I have a question regarding the timer broadcast.

The broadcast timer is setup to the next event and that will wake up any
idle cpu belonging to the "broadcast cpumask", right ?

The cpu which has been woken up will look for each cpu the next-event
and send an IPI to wake it up.

Although, it is possible the sender of this IPI may not be concerned by
the timer expiration and has been woken up just for sending the IPI, right ?

If this is correct, is it possible to setup the timer irq affinity to a
cpu which will be concerned by the timer expiration ? so we prevent an
unnecessary wake up for a cpu.

For example, let's say we have a 2 cpus system.

cpu0, cpu1 are idle

The next event is for cpu1 but cpu0 is wake up by the broadcast timer,
after checking it has nothing to do except send a IPI_TIMER to cpu1 and
then goes to idle again.

Wouldn't be worth to set the broadcast timer affinity to cpu1, so cpu0
is not wake up ?

Did I missed something or does it sound correct ?

Thanks
  -- Daniel



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

