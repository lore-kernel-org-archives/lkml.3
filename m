Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbaGCRjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:39:52 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:39164 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaGCRjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:39:51 -0400
X-ME-Helo: beldin
X-ME-Date: Thu, 03 Jul 2014 19:39:50 +0200
X-ME-IP: 90.38.42.162
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] clocksource: add device-tree support for PXA timer
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
	<1403388588-11956-2-git-send-email-robert.jarzmik@free.fr>
	<53B5470D.4070009@linaro.org> <87tx6ynybb.fsf@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 03 Jul 2014 19:39:49 +0200
In-Reply-To: <87tx6ynybb.fsf@free.fr> (Robert Jarzmik's message of "Thu, 03
	Jul 2014 19:31:52 +0200")
Message-ID: <87pphmnxy2.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Daniel Lezcano <daniel.lezcano@linaro.org> writes:
>
>>> -#include <mach/regs-ost.h>
>>>   #include <mach/irqs.h>
>>> +#include <mach/hardware.h>
>>
>> Now as the driver is in 'drivers', do not reference the headers files in
>> mach. Moving the driver to the drivers directory implies some cleanup with the
>> headers dependencies.
> I don't see that very possible.
> Or said another way, I don't see how the irq number, IRQ_OST0 (in mach/irqs.h)
> can be guessed for non device-tree configuration.
Oh yeah, a simple parameter to pxa_init_timer() will do the trick ...

> Another question brought up by this : if I remove all 'mach/' includes, I loose
> io_p2v() right ? How can I guess timer_base then ?
And same answer here, a simple parameter to pxa_init_timer() will solve this
too.

Cheers.

--
Robert
