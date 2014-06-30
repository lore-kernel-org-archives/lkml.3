Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaF3FPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:15:13 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61524 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaF3FPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:15:11 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1404075022-28745-2-git-send-email-afaerber@suse.de>
References: <1404075022-28745-1-git-send-email-afaerber@suse.de>
	<1404075022-28745-2-git-send-email-afaerber@suse.de>
Date: Sun, 29 Jun 2014 22:15:10 -0700
Message-ID: <CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: dts: zynq: Add Parallella device tree
From: Olof Johansson <olof@lixom.net>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 29, 2014 at 1:50 PM, Andreas Färber <afaerber@suse.de> wrote:
> This allows to boot the Adapteva Parallella board to serial console.
>
> Cc: Andreas Olofsson <andreas@adapteva.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>

Nice and clean DTS, just a couple of comments below.

> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
> new file mode 100644
> index 0000000..98df66c
> --- /dev/null
> +++ b/arch/arm/boot/dts/zynq-parallella.dts
> @@ -0,0 +1,63 @@
> +/*
> + * Copyright (c) 2014 SUSE LINUX Products GmbH
> + *
> + * Derived from zynq-zed.dts:
> + *
> + *  Copyright (C) 2011 Xilinx
> + *  Copyright (C) 2012 National Instruments Corp.
> + *  Copyright (C) 2013 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +/dts-v1/;
> +/include/ "zynq-7000.dtsi"
> +
> +/ {
> +       model = "Parallella Board";
> +       compatible = "xlnx,zynq-7000";

This should have a more specific compatible as the first one. Probably
something like:
   compatible = "adapteva,parallella", "xlnx,zynq-7000";

> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0 0x20000000>;

Does the bootloader update this entry, or is it truly static? If it's
updated then it's become recent habit to leave the memory size empty
in the static file.

> +       };
> +
> +       chosen {
> +               bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
> +       };
> +};

A bit more torn on this one, I'm OK with it staying in even if
firmware overrides for all practical purposes since it's good to keep
around for reference w.r.t. console. Note that we're starting to move
over to using /chosen/stdout-path, so you might want to add that now
instead of later.


-Olof
