Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935579Ab3DHSZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:25:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62228 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462Ab3DHSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:25:29 -0400
Message-ID: <51630B93.3020702@gmail.com>
Date: Tue, 09 Apr 2013 03:25:23 +0900
From: Kukjin Kim <kgene.kim@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Padmavathi Venna <padma.v@samsung.com>,
        Giridhar Maruthy <giridhar.m@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: Disable the RTC by default on exynos5
References: <1365440295-4460-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1365440295-4460-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/13 01:58, Doug Anderson wrote:
> This change makes the rtc on the exynos5250 and 5440 disabled by
> default to match exynos4.
>
> Ever since the common clock framework came in came in, exynos5250
> boards have dumped lots of warnings in the boot log.  It turns out
> that we don't see those on exynos4 since the rtc is disabled by
> default.  While we need to get to the bottom of the problems with the
> RTC, it still makes sense to have the default state of the RTC on
> exynos boards match.
>
> For the record, warnings look like this:
>    ------------[ cut here ]------------
>    WARNING: at /.../drivers/clk/clk.c:771 __clk_enable+0x34/0xb0()
>    Modules linked in:
>    [<80015bfc>] (unwind_backtrace+0x0/0xec) from [<804717f0>] (dump_stack+0x20/0x24)
>    [<804717f0>] (dump_stack+0x20/0x24) from [<80023cd0>] (warn_slowpath_common+0x5c/0x7c)
>    [<80023cd0>] (warn_slowpath_common+0x5c/0x7c) from [<80023d1c>] (warn_slowpath_null+0x2c/0x34)
>    [<80023d1c>] (warn_slowpath_null+0x2c/0x34) from [<8035ddb0>] (__clk_enable+0x34/0xb0)
>    [<8035ddb0>] (__clk_enable+0x34/0xb0) from [<8035de54>] (clk_enable+0x28/0x3c)
>    [<8035de54>] (clk_enable+0x28/0x3c) from [<8031a160>] (s3c_rtc_probe+0xf4/0x434)
>    [<8031a160>] (s3c_rtc_probe+0xf4/0x434) from [<8028e288>] (platform_drv_probe+0x24/0x28)
>    [<8028e288>] (platform_drv_probe+0x24/0x28) from [<8028ce10>] (driver_probe_device+0xbc/0x22c)
>    [<8028ce10>] (driver_probe_device+0xbc/0x22c) from [<8028cff8>] (__driver_attach+0x78/0x9c)
>    [<8028cff8>] (__driver_attach+0x78/0x9c) from [<8028bdfc>] (bus_for_each_dev+0x64/0xac)
>    [<8028bdfc>] (bus_for_each_dev+0x64/0xac) from [<8028c7e0>] (driver_attach+0x28/0x30)
>    [<8028c7e0>] (driver_attach+0x28/0x30) from [<8028c43c>] (bus_add_driver+0xe0/0x234)
>    [<8028c43c>] (bus_add_driver+0xe0/0x234) from [<8028d55c>] (driver_register+0xac/0x13c)
>    [<8028d55c>] (driver_register+0xac/0x13c) from [<8028e4f4>] (platform_driver_register+0x54/0x68)
>    [<8028e4f4>] (platform_driver_register+0x54/0x68) from [<8065c944>] (s3c_rtc_driver_init+0x14/0x1c)
>    [<8065c944>] (s3c_rtc_driver_init+0x14/0x1c) from [<800086d8>] (do_one_initcall+0x60/0x138)
>    [<800086d8>] (do_one_initcall+0x60/0x138) from [<80633a8c>] (kernel_init_freeable+0x108/0x1d0)
>    [<80633a8c>] (kernel_init_freeable+0x108/0x1d0) from [<8046d2f8>] (kernel_init+0x1c/0xf4)
>    [<8046d2f8>] (kernel_init+0x1c/0xf4) from [<8000e358>] (ret_from_fork+0x14/0x20)
>    ---[ end trace 4bcdc801c868d73f ]---
>
> Signed-off-by: Doug Anderson<dianders@chromium.org>
> ---
>   arch/arm/boot/dts/exynos5250.dtsi | 1 +
>   arch/arm/boot/dts/exynos5440.dtsi | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index dc55e33..892b724 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -183,6 +183,7 @@
>   		interrupts =<0 43 0>,<0 44 0>;
>   		clocks =<&clock 337>;
>   		clock-names = "rtc";
> +		status = "disabled";
>   	};
>
>   	tmu@10060000 {
> diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
> index 25c6134..a8ceef4 100644
> --- a/arch/arm/boot/dts/exynos5440.dtsi
> +++ b/arch/arm/boot/dts/exynos5440.dtsi
> @@ -181,5 +181,6 @@
>   		interrupts =<0 17 0>,<0 16 0>;
>   		clocks =<&clock 21>;
>   		clock-names = "rtc";
> +		status = "disabled";
>   	};
>   };

Ooops, OK.

Applied, thanks.

- Kukjin
