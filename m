Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbaGDTqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:46:36 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:60060 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaGDTqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:46:34 -0400
X-ME-Helo: beldin
X-ME-Date: Fri, 04 Jul 2014 21:46:33 +0200
X-ME-IP: 86.199.194.180
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] clocksource: add device-tree support for PXA timer
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
	<1403388588-11956-2-git-send-email-robert.jarzmik@free.fr>
	<53B5470D.4070009@linaro.org> <87tx6ynybb.fsf@free.fr>
	<53B6471D.3010001@linaro.org>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 04 Jul 2014 21:46:30 +0200
In-Reply-To: <53B6471D.3010001@linaro.org> (Daniel Lezcano's message of "Fri,
	04 Jul 2014 08:18:05 +0200")
Message-ID: <874mywoqjt.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

>> Good question.
>>
>> Maybe not, I followed the same rationale as in orion-timer, which is :
>>   - as this timer is the only possible timer for PXA boards, and because without
>>   it the kernel boot will stall (scheduling will be blocked), it's better to
>>   panic early that to remain stalled.
>
> There isn't the arm global timer ?
Nope, it's for Cortex-A9 AFAIK, and my poor platform is an old ARMv5 SoC.

>
>> Isn't this a good approach ?
>
> I suppose we can live with that. IMO, the right fix would be in clksrc-of to
> pr_crit a message when an initialization fails. But that means to change all the
> init functions for all drivers which is out of the scope of this patchset.
OK, you convinced me. I'll trade the panic() for a pr_crit(). Good idea, maybe
it will trigger a quest of a white knight for the other drivers :)

Cheers.

-- 
Robert
