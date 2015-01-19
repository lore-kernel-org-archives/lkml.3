Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbbASJ17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:27:59 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48761 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbASJ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:27:57 -0500
Message-ID: <54BCCE16.8050607@linaro.org>
Date: Mon, 19 Jan 2015 10:27:50 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, Kukjin Kim <kgene@kernel.org>
CC: tglx@linutronix.de, inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com> <54B69072.4080607@kernel.org> <54B692FB.7030703@linaro.org> <54BC55BB.7050809@samsung.com>
In-Reply-To: <54BC55BB.7050809@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 01:54 AM, Chanwoo Choi wrote:
> Dear Daniel and Kukjin,
>
> On 01/15/2015 01:02 AM, Daniel Lezcano wrote:
>> On 01/14/2015 04:51 PM, Kukjin Kim wrote:
>>> On 01/14/15 14:33, Chanwoo Choi wrote:
>>>
>>> Hi,
>>>
>>> + Doug, Olof
>>>
>>>> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
>>>> for Exynos 32bit SoC.
>>>>
>>> Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
>>> on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
>>> including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
>>> implemented it and additionally its access is faster than using memory
>>> mapped register called SFR for MCT...so Doug submitted patch to use MCT
>>> on 32bit exynos SoCs before.
>>>
>>> I know using MCT on 64bit exynos is usefulness for Power Management and
>>> I need to talk to relevant guys in office again. If anything, I'll let
>>> you know.
>>
>> I will wait for your answer before digging more the patch.

Hi Chanwoo,

[ ... ]

> Do you have any comment about this patch?

Yes, a similar patch has been posted for the tegra2 timer to run on 
arm64. The patch in question put macros #ifdef CONFIG_ARM64 to disable 
some parts of the code. That ended, the tegra2 timer was not needed for 
the moment because of the arch timer present, so it has been disabled 
from the compilation until a proper fix without macros could be proposed.

It is happening exactly the same with this patch. As Kukjin pointed it, 
the exynos_mct may not be needed (at least until a backup timer is 
needed at PM time).

I suggest you look at a nicer way to fix that instead of introducing 
macros (which is by the way valid but not recommended by the CodingStyle 
rules) and perhaps sync with Paul and Thierry [cc'ed] to find a common 
solution.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

