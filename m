Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaKYJXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:23:03 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52723 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:23:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b6-54744a71092a
Message-id: <1416907375.5023.54.camel@AMDC1943>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Date: Tue, 25 Nov 2014 10:22:55 +0100
In-reply-to: <54736AD0.4070909@collabora.co.uk>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
 <54736AD0.4070909@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xa7qFXiUhBn2N0hZtVw6yWxz9XWDR
	//g1s8XTzY+ZLDY9vsZqcXnXHDaLGef3MVk8nXCRzeLwm3ZWi1W7/jA6cHn8fX6dxWPnrLvs
	HptWdbJ53Lm2h81j85J6j74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MroaHjBXPBBqmLT6R6W
	Bsbpol2MnBwSAiYSx673MUPYYhIX7q1n62Lk4hASWMoo0XhgFiuE85lR4uOa3SwgVbwC+hLT
	ru4As4UF/CU2TZwHZrMJGEtsXr6EDcQWEbCTuLH6ITNIM7PADSaJB5cOs4IkWARUJc63/AMr
	4gQaNHHHTEYQW0ggW+Lw12VgNcwC6hKT5i0CauYAOklZorHfDWKvoMSPyfdYIErkJTavecs8
	gVFgFpKOWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJCq+7mBceszqEKMA
	B6MSD2+FZnGIEGtiWXFl7iFGCQ5mJRHeqHlAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxGU/xj
	ju67xJI70flymt87j/6yhet4H0/ad7ox7/y349pNPL/7tI5f1Oy9I8smc9PRdHXIjYKdT44d
	9izcqVqy5o59T6T+jta7PseWFr8QWsT45qt8cEasH9+WnxHaMxVP3jud6353SfzdKa5T9Ay/
	CHPH9zzLZrz4yWOHd6ztdpYkZ4lzT94psRRnJBpqMRcVJwIAZPUmv2gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-24 at 18:28 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 11/24/2014 04:18 PM, Krzysztof Kozlowski wrote:
> > Hi,
> > 
> > 
> > This is initial idea to solve dependency between AudioSS clocks
> > and main clock controller on Exynos platform.
> > 
> > This solves boot failure of Peach Pi/Pit and Arndale Octa [1].
> > 
> 
> I tested this series on an Exynos5420 Peach Pit but I still
> have the boot hang so it doesn't solve the issue on this board.
> 
> I'm using linux-next + your patches with exynos_defconfig and
> without the clk_ignore_unused command line parameter.

Hmmm, that's strange. I've looked again at your dmesg and it is little
different than mine (when system fails).
1. Does your PMIC come up? In your dmesg:
[    2.687297] max77802-pmic max77802-pmic: regulator init failed for 0
[    2.693539] platform max77802-pmic: Driver max77802-pmic requests probe deferral

2. In my case booting fails just after disabling unused clocks which is
quite early, my dmesg:
[   11.700074] input: gpio_keys as /devices/platform/gpio_keys/input/input0
[   11.704282] s3c-rtc 101e0000.rtc: setting system clock to 2029-01-11 19:19:17 UTC (1862853557)
[   11.770602] mmcblk0: mmc0:0001 M8G1WA 7.28 GiB
[   11.776201] mmcblk0boot0: mmc0:0001 M8G1WA partition 1 2.00 MiB
[   11.780968] mmcblk0boot1: mmc0:0001 M8G1WA partition 2 2.00 MiB
[   11.786823] mmcblk0rpmb: mmc0:0001 M8G1WA partition 3 128 KiB
[   11.793815]  mmcblk0: p1 p2 p3 p4
[   11.824165] PVDD_G3D_1V0: disabling
[   11.830833] PVDD_G3DS_1V0: disabling
[   11.837771] PVDD_HSIC_1V8: disabling
[   11.841172] PVDD_ABB_1V8: disabling
[   11.844866] PVDD_ANAIP_1V8: disabling
[   11.847157] usb 5-1.4: new high-speed USB device number 3 using exynos-ehci
[   11.848778] PVDD

In your case you have a gap here:
[    3.624142] platform 12d10000.adc: Driver exynos-adc requests probe deferral
[   24.188722] random: nonblocking pool is initialized

Could you try my patches once again but this time with enabled:
DEBUG_EXYNOS_UART
EARLY_PRINTK
DEBUG_S3C_UART3
DEBUG_LL

and with following change:

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9e23da..316856e55784 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -478,7 +478,9 @@ static void clk_disable_unused_subtree(struct clk *clk)
         * sequence.  call .disable_unused if available, otherwise fall
         * back to .disable
         */
+       pr_err("clk: checking %s\n", clk->name);
        if (__clk_is_enabled(clk)) {
+               pr_err("clk: enabled %s, disabling\n", clk->name);
                if (clk->ops->disable_unused)
                        clk->ops->disable_unused(clk->hw);
                else if (clk->ops->disable)

Without my patch the boot hangs:
[   12.230666] clk: checking dout_unipro
[   12.234304] clk: checking mout_unipro
[   12.237913] clk: checking sclk_usbd300
[   12.241638] clk: enabled sclk_usbd300, disabling
[   12.246264] clk: checking dout_usbd300
[   12.249992] clk: checking sclk_usbd301
[   12.253683] clk: enabled sclk_usbd301, disabling
[   12.258309] clk: checking dout_usbd301
[   12.262007] clk: checking sclk_maudio0
[   12.265728] clk: enabled sclk_maudio0, disabling
[   12.270355] clk: checking pcm_bus

because audss seems to be gated so kernel cannot access status of
pcm_bus clock.

Best regards,
Krzysztof


