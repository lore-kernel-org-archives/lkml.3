Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919Ab3B0FDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:03:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47731 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab3B0FDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:03:06 -0500
Message-ID: <512D93D5.3010501@ti.com>
Date: Wed, 27 Feb 2013 10:34:21 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, <john.stultz@linaro.org>,
        <tglx@linutronix.de>, <jacob.jun.pan@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <linus.walleij@stericsson.com>
Subject: Re: [PATCH 4/4] ARM: timer-sp: Set dynamic irq affinity
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <1361917047-29230-5-git-send-email-daniel.lezcano@linaro.org> <512D91E8.6050706@ti.com> <CAKohpomj1mueL9NETb1xfXTpnKnXCtb9Secu3q5vZTS9dJd0Vg@mail.gmail.com>
In-Reply-To: <CAKohpomj1mueL9NETb1xfXTpnKnXCtb9Secu3q5vZTS9dJd0Vg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2013 10:29 AM, Viresh Kumar wrote:
> On 27 February 2013 10:26, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> On Wednesday 27 February 2013 03:47 AM, Daniel Lezcano wrote:
>>>
>>> From: Viresh Kumar <viresh.kumar@linaro.org>
>>>
>>> When a cpu goes to a deep idle state where its local timer is shutdown, it
>>> notifies the time frame work to use the broadcast timer instead.
>>>
>>> Unfortunately, the broadcast device could wake up any CPU, including an
>>> idle one
>>> which is not concerned by the wake up at all.
>>>
>> Broad-cast device will only open the CPU for which the timer IRQ
>> affined to. And infact with subject series the affinity also is
>> updated for the CPU which owns the last timer expiry event.
>>
>> What am I missing here ?
>
> Dynamic affinity will work only if the following flag is set for a
> clock_event_device: CLOCK_EVT_FEAT_DYNIRQ, otherwise wakeup
> would happen on the cpu to which static affinity was set to.
>
I should have looked at the patches in order first :)
Sorry for the noise.

Regards,
Santosh
