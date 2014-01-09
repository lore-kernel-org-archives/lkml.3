Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaAIBuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:50:24 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36858 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAIBuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:50:20 -0500
Message-ID: <52CE005A.3070802@codeaurora.org>
Date: Wed, 08 Jan 2014 17:50:18 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v2 0/9] CPU enable method based SMP/hotplug + MSM conversion
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org> <201401082237.36626.arnd@arndb.de>
In-Reply-To: <201401082237.36626.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 13:37, Arnd Bergmann wrote:
> On Tuesday 24 December 2013, Stephen Boyd wrote:
>> This is a rework of patches sent a months back by Rohit[1].
>> The goal of these patches is to add support for SMP and (basic)
>> hotplug on MSM based SoCs. To get there, we add support for a
>> generic way to hook in SMP/hotplug support code based on DT. To
>> show how it's used, we convert the MSM8660 SMP support code over
>> to the new method. After that we add support for the rest of the
>> upstream MSM SoCs (note these patches are piled high on top of
>> Rohit's patches to add 8074 support to MSM[2] and my follow ups[3,4],
>> but this should only matter to the MSM maintainers).
>>
>> This is one of the last items of code that still requires us to have
>> a mach directory and a machine descriptor. We should be able to move
>> the hotplug/smp code out of mach directories if this approach is
>> accepted.
> The implementation looks ok to me, but I wonder whether on a global
> scale we want to tie it more closely to the cpuidle implementations.
> We already have a drivers/cpuidle framework, and while I admit
> that I'm not familiar with the code in there, I would assume that
> the smp operations and the cpuidle code usually go hand in hand.

Sure. Right now the smp ops code is fairly well tied into the arch layer
so it sounds like there is some future work when we move this stuff out
of the mach directory.

Would arm-soc be able to pick these patches up for 3.14? I think
everything is in place for these patches now that Mark has reviewed them.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

