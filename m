Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaGIMLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:11:14 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65278 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaGIMLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:11:10 -0400
Message-ID: <53BD3157.7030804@gmail.com>
Date: Wed, 09 Jul 2014 17:41:03 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        Doug Anderson <dianders@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 2/3] ARM: dts: Update the parent for Audss clocks in Exynos5420
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>	<1402464739-19044-3-git-send-email-tushar.b@samsung.com>	<CAD=FV=W5yh58fYTwRZxmZt=BORcZMSRV0oRe12yA74Q5h2S4YQ@mail.gmail.com>	<7hpphwlgn0.fsf@paris.lan>	<CAC5m3Bzey-YoPLmjAq4YNPQ13rojtVFWAbnhX6-ZFtYZwEdMWg@mail.gmail.com>	<7h8uojk61a.fsf@paris.lan>	<53ACE724.7090606@gmail.com>	<CAGa+x86COQz+cYtrXWrP-sjFGz-gi2tf6GEvLiKYoQwg1zMivQ@mail.gmail.com>	<CAGa+x87LHiYGb03=GRcZisK1=TyakW1htd1E2vOQ6ijZKw8syg@mail.gmail.com>	<53B2A2A5.4070203@gmail.com>	<53BB2E7A.5080204@samsung.com>	<53BB5EBD.5030607@gmail.com> <CABxcv=ka5UxZ8E3+F4cR4vcY1m3AfX=g7HiaNYqmyQjHfSVqtw@mail.gmail.com>
In-Reply-To: <CABxcv=ka5UxZ8E3+F4cR4vcY1m3AfX=g7HiaNYqmyQjHfSVqtw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 03:44 PM, Javier Martinez Canillas wrote:
> Hello Tushar,
> 
> On Tue, Jul 8, 2014 at 5:00 AM, Tushar Behera <trblinux@gmail.com> wrote:
>>>>
>>>> The u-boot version is a little different on my Peach-Pi as compared to
>>>> the market release version. Not sure if that is making any difference.
>>>>
>>>> Peach # version
>>>>
>>>> U-Boot 2013.04 (Feb 13 2014 - 16:35:03) for Peach
>>>> armv7a-cros-linux-gnueabi-gcc.real (4.8.1_cos_gg_feea904_4.8.1-r66)
>>>> 4.8.x-google 20130905 (prerelease)
>>>> GNU ld (binutils-2.22_cos_gg_2) 2.22
>>>>
>>>
> 
> I'm using the same U-Boot version than Kevin (U-Boot 2013.04-gb98ed09)
> and on my setup using chained nv-uboot I also need patch 1/3 along
> with 2/3 to fix the issue.
> 
>>> Note that I've applied this only from this series so I'm not sure how
>>> much the problem can be solved...any updates for 1/3 and 3/3?
>>>
>>> - Kukjin
>>
>> Thanks for applying 2/3. I am working on 1/3 to see if we are following
>> the right approach to fix Kevin's issue (unfortunately, I am not hitting
>> the bug on my board ATM). 3/3 has already been merged through a
>> different patchset.
>>
> 
> I'm sending as an attachment my complete boot log when booting today's
> next (20140709) until it hangs and my u-boot env vars. I hope that
> helps.
> 

Would you please check the behaviour after enabling following config
options?

diff --git a/arch/arm/configs/exynos_defconfig
b/arch/arm/configs/exynos_defconfig
index e07a227..d6056ab 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -93,6 +93,11 @@ CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FONTS=y
 CONFIG_FONT_7x14=y
 CONFIG_LOGO=y
+CONFIG_SOUND=y
+CONFIG_SND=y
+CONFIG_SND_SOC=y
+CONFIG_SND_SOC_SAMSUNG=y
+CONFIG_SND_SOC_SNOW=y
 CONFIG_USB=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_EXYNOS=y
@@ -109,6 +114,8 @@ CONFIG_MMC_DW_IDMAC=y
 CONFIG_MMC_DW_EXYNOS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S3C=y
+CONFIG_DMADEVICES=y
+CONFIG_PL330_DMA=y
 CONFIG_COMMON_CLK_MAX77686=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y


>> --
>> Tushar Behera
>> --
> 
> Best regards,
> Javier
> 


-- 
Tushar Behera
