Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3DMNEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:04:21 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:65053 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3DMNEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <1365651529-11545-1-git-send-email-zhangwm@marvell.com>
References: <1365651529-11545-1-git-send-email-zhangwm@marvell.com>
Date: Sat, 13 Apr 2013 21:04:18 +0800
Message-ID: <CAN1soZxhXW=pNGihz6g4arK0zWi7_rzXQyJfuuat0d+Yw+P0Gg@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: mmp: bring up pxa988 with device tree support
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <chao.xie@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:38 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> bring up pxa988 with device tree support.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  arch/arm/boot/dts/pxa988-dkb.dts          |   36 ++++++
>  arch/arm/boot/dts/pxa988.dtsi             |  196 +++++++++++++++++++++++++++++
>  arch/arm/mach-mmp/Kconfig                 |   25 ++++
>  arch/arm/mach-mmp/Makefile                |    1 +
>  arch/arm/mach-mmp/common.c                |   11 ++-
>  arch/arm/mach-mmp/include/mach/addr-map.h |    6 +
>  arch/arm/mach-mmp/mmpx-dt.c               |   79 ++++++++++++
>  drivers/clk/mmp/Makefile                  |    1 +
>  8 files changed, 354 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/boot/dts/pxa988-dkb.dts
>  create mode 100644 arch/arm/boot/dts/pxa988.dtsi
>  create mode 100644 arch/arm/mach-mmp/mmpx-dt.c
>
> diff --git a/arch/arm/boot/dts/pxa988-dkb.dts b/arch/arm/boot/dts/pxa988-dkb.dts
> new file mode 100644
> index 0000000..2cee3ed
> --- /dev/null
> +++ b/arch/arm/boot/dts/pxa988-dkb.dts
> @@ -0,0 +1,36 @@
> +/*
> + *  Copyright (C) 2012 Marvell Technology Group Ltd.
> + *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  publishhed by the Free Software Foundation.
> + */
> +
> +/dts-v1/;
> +/include/ "pxa988.dtsi"
> +
> +
> +                       gpio@d4019000 {
> +                               compatible = "mrvl,mmp-gpio";
Since gpio-pxa driver is updated & merged just now, you need
to update this as "marvell,mmp-gpio".

> +
> +/* PXA988 */
> +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst = {
> +       OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
> +       OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
> +       OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
> +       OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
> +       OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
> +       OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
"marvell,mmp-gpio"
