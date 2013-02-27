Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab3B0E7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 23:59:13 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:46588 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3B0E7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 23:59:11 -0500
MIME-Version: 1.0
In-Reply-To: <512D91E8.6050706@ti.com>
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org>
	<1361917047-29230-5-git-send-email-daniel.lezcano@linaro.org>
	<512D91E8.6050706@ti.com>
Date: Wed, 27 Feb 2013 10:29:11 +0530
Message-ID: <CAKohpomj1mueL9NETb1xfXTpnKnXCtb9Secu3q5vZTS9dJd0Vg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: timer-sp: Set dynamic irq affinity
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, john.stultz@linaro.org,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2013 10:26, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> On Wednesday 27 February 2013 03:47 AM, Daniel Lezcano wrote:
>>
>> From: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> When a cpu goes to a deep idle state where its local timer is shutdown, it
>> notifies the time frame work to use the broadcast timer instead.
>>
>> Unfortunately, the broadcast device could wake up any CPU, including an
>> idle one
>> which is not concerned by the wake up at all.
>>
> Broad-cast device will only open the CPU for which the timer IRQ
> affined to. And infact with subject series the affinity also is
> updated for the CPU which owns the last timer expiry event.
>
> What am I missing here ?

Dynamic affinity will work only if the following flag is set for a
clock_event_device: CLOCK_EVT_FEAT_DYNIRQ, otherwise wakeup
would happen on the cpu to which static affinity was set to.
