Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3E3VXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:23:53 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.3]:19735 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757555Ab3E3VXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:23:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1369949025!7586649!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Ryan Mallon (rmallon@gmail.com)" <rmallon@gmail.com>,
        "rob@landley.net" <rob@landley.net>
Date: Thu, 30 May 2013 16:20:53 -0500
Subject: RE: [PATCH v2] pwm: add sysfs interface
Thread-Topic: [PATCH v2] pwm: add sysfs interface
Thread-Index: Ac5dctT2ZepyUv0DRuCUGd/5xRtLTAACCmzQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA67E418A@AUSP01VMBX24.collaborationhost.net>
References: <201305301230.11569.hartleys@visionengravers.com>
In-Reply-To: <201305301230.11569.hartleys@visionengravers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4ULNu56020715

On Thursday, May 30, 2013 12:30 PM, H Hartley Sweeten wrote:
> Add a simple sysfs interface to the generic PWM framework.
>
>   /sys/class/pwm/
>   `-- pwmchipN/          for each PWM chip
>       |-- export         (w/o) ask the kernel to export a PWM channel
>       |-- npwn           (r/o) number of PWM channels in this PWM chip
>       |-- pwmX/          for each exported PWM channel (per PWM chip)
>       |   |-- duty_ns    (r/w) duty cycle (in nanoseconds)
>       |   |-- enable     (r/w) enable/disable PWM
>       |   |-- period_ns  (r/w) period (in nanoseconds)
>       |   `-- polarity   (r/w) polarity of PWM
>       `-- unexport       (w/o) return a PWM channel to the kernel
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Lars Poeschel <poeschel@lemonage.de>
> Cc: Ryan Mallon <rmallon@gmai.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> v2: * add API documentation and update Documentation/pwm.txt
>     * fix some issues pointed out by Ryan Mallon
>     * add the pwm attributes to dev.groups so they are created
>       when the device is registered for the exported PWM.
>
>  Documentation/ABI/testing/sysfs-class-pwm |  80 +++++++
>  Documentation/pwm.txt                     |  39 ++++
>  drivers/pwm/Kconfig                       |  12 +
>  drivers/pwm/Makefile                      |   1 +
>  drivers/pwm/core.c                        |  25 ++-
>  drivers/pwm/pwm-sysfs.c                   | 350 ++++++++++++++++++++++++++++++
>  include/linux/pwm.h                       |  28 +++
>  7 files changed, 533 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-pwm
>  create mode 100644 drivers/pwm/pwm-sysfs.c

<snip>

> diff --git a/drivers/pwm/pwm-sysfs.c b/drivers/pwm/pwm-sysfs.c

<snip>

> +void pwmchip_sysfs_export(struct pwm_chip *chip)
> +{
> +	/*
> +	 * If device_create() fails the pwm_chip is still usable by
> +	 * the kernel its just not exported.
> +	 */
> +	chip->dev = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> +				  "pwmchip%d", chip->base);
> +}

I just realized this will not work.

chip->dev is initialized by the PWM driver before calling pwmchip_add().

I'll post a v3 shortly.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
