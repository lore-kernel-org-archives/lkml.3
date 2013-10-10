Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3JJWqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:46:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52931 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3JJWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:46:14 -0400
Message-ID: <52572E33.2090609@codeaurora.org>
Date: Thu, 10 Oct 2013 15:46:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com> <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com> <52436EBE.9010002@codeaurora.org> <20131010191311.GL3041@lukather>
In-Reply-To: <20131010191311.GL3041@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/13 12:13, Maxime Ripard wrote:
> On Wed, Sep 25, 2013 at 04:16:14PM -0700, Stephen Boyd wrote:
>> On 09/25/13 07:03, Maxime Ripard wrote:
>>> +	sun5i_clockevent.cpumask = cpumask_of(0);
>> Can this timer interrupt any CPU or is it hardwired to CPU0? If the
>> interrupt can go to any CPU this should be cpu_possible_mask instead.
> I've changed the few other things you spotted, but this one making the
> timer unusable.
>
> I think what happens here is that we have the A31 I've tested these
> patches on is a quad-core SoC. As such, the device tree has 4 CPUs
> declared. However, we don't have any SMP support for it now. So we end
> up having 4 cpus set as possible, and only one online (the boot cpu),
> which isn't working.

Can you explain more why it isn't working? Is the timer being rejected
in favor of another timer?

>
> Would using cpu_online_mask work in our case?

It may work but it's probably hiding a problem with CONFIG_SMP=y

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

