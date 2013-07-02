Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3GBAGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:06:44 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33765 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3GBAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:06:42 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: <tony@atomide.com>, <b-cousson@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 1/4] rtc: omap: restore back (hard-code) wakeup support
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
	<1372412109-986-2-git-send-email-gururaja.hebbar@ti.com>
Date: Mon, 01 Jul 2013 17:06:38 -0700
In-Reply-To: <1372412109-986-2-git-send-email-gururaja.hebbar@ti.com> (Hebbar
	Gururaja's message of "Fri, 28 Jun 2013 15:05:06 +0530")
Message-ID: <87ehbhomep.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hebbar Gururaja <gururaja.hebbar@ti.com> writes:

> rtc-omap driver modules is used both by OMAP1/2, Davinci SoC platforms.
>
> However, rtc wake support on OMAP1 is broken. Hence the
> device_init_wakeup() was removed from rtc-omap driver and moved to
> platform board files that supported it (DA850/OMAP-L138). [1]
>
> However, recently [2] it was suggested that driver should always do a
> device_init_wakeup(dev, true). Platforms that don't want/need
> wakeup support can disable it from userspace via:
>
>     echo disabled > /sys/devices/.../power/wakeup
>
> Also, with the new DT boot-up, board file doesn't exist and hence there
> is no way to have device wakeup support rtc.
>
> The fix for above issues, is to hard code device_init_wakeup() inside
> driver and let platforms that don't need this, handle it through the
> sysfs power entry.
>
> [1]
> https://patchwork.kernel.org/patch/136731/
>
> [2]
> http://www.mail-archive.com/davinci-linux-open-source@linux.
> davincidsp.com/msg26077.html
>
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com

Acked-by: Kevin Hilman <khilman@linaro.org>

> ---
> :100644 100644 b0ba3fc... 761919d... M	drivers/rtc/rtc-omap.c
>  drivers/rtc/rtc-omap.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index b0ba3fc..761919d 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -423,6 +423,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
>  	 *    is write-only, and always reads as zero...)
>  	 */
>  
> +	device_init_wakeup(&pdev->dev, true);
> +
>  	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
>  		pr_info("%s: split power mode\n", pdev->name);
