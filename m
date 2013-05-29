Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab3E2EAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:00:05 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56789 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab3E2EAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:00:02 -0400
Message-ID: <51A57D39.8030506@linaro.org>
Date: Wed, 29 May 2013 09:29:53 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Kevin Hilman <khilman@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dianders@chromium.org, patches@linaro.org
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen
 board
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org> <87sj1qzaov.fsf@linaro.org> <5191AA89.6010901@linaro.org> <20130528231740.GA28879@quad.lixom.net>
In-Reply-To: <20130528231740.GA28879@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 04:47 AM, Olof Johansson wrote:
> On Tue, May 14, 2013 at 08:37:53AM +0530, Tushar Behera wrote:
>> On 05/14/2013 05:36 AM, Kevin Hilman wrote:
>>> Tushar Behera <tushar.behera@linaro.org> writes:
>>>
>>>> It updates following drivers for EXYNOS based DT platform.
>>>>
>>>> * S5M8767 driver
>>>> * MAX8997 driver
>>>> * MMC SDHCI driver
>>>>
>>>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>>>
>>> I tested this using v3.10-rc1 on Arndale, but still don't get any
>>> support for the wired network.  Do you know if this is a Kconfig issue,
>>> or a missing driver?
>>>
>>> I suspect it may be related to the various "unable to find transceiver
>>> of type USB2 PHY" messages I'm seeing?
>>>
>>
>> Yes, right. The missing USB-PHY components are one of the issues (they
>> were there in linux-next when I last tested).
>>
>> Also, on Arndale board, we need to reset the USB hub during EHCI
>> initialization (a couple of those patches are required, which I am not
>> sure if we would be able to upstream).
>>
>> I am collecting a minimal set of patches that would enable USB and wired
>> network on Arndale with 3.10-rc1 kernel. Once done, I will let you know.
> 
> Hi Tushar,
> 
> Got an update on what these patches are yet?
> 
> 
> -Olof
> 

The patches are at [1]. There are a total of 6 patches on top of
v3.10-rc3. 3 of them (a, b, d) are queued for 3.10-rc4 and another patch
(c) is just a defconfig hack to get Arndale booting. Remaining 2 patches
(e, f) are required to reset the hub during EHCI initialization.

a. ARM: exynos: defconfig update
b. ARM: EXYNOS: Update defconfig for Arndale and Origen board
c. [TEMP] ARM: EXYNOS: Set low-level UART port to 2
d. ARM: dts: Enabling samsung-usb2phy driver for exynos5250
e. usb: ehci-s5p: add the HSIC port initialization
f. ARM: dts: Add USB gpio entries for Arndale board

I am not sure whether such kind of board-specific patches (e, f) are
appreciated in the drivers. But that is all we need to get USB and
Ethernet to work on v3.10-rc3 kernel.

[1] git://git.linaro.org/landing-teams/working/samsung/kernel.git
(upstream/arndale-usb)

-- 
Tushar Behera
