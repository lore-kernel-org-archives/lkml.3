Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaCJPtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:49:33 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:32934 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaCJPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <1394195917-25166-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394195917-25166-1-git-send-email-florian.vaussard@epfl.ch>
Date: Mon, 10 Mar 2014 10:49:29 -0500
Message-ID: <CAL_JsqJugFL6ZbRyZhC7hOWU+rSowzXB84=LjPso8jJ_2ohMHw@mail.gmail.com>
Subject: Re: [PATCH] of: add missing major vendors
From: Rob Herring <robherring2@gmail.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 6:38 AM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> Looking at the current vendor strings used in the kernel's .dts/.dtsi
> files, some vendors are used a high number of times without
> being documented. Document the ones that are used more than 10 times.
>
> Note: a few inconsistencies were found, and thus not documented.
> Here is the list:
> - mrvl: duplicates "marvell"

There was a whole thread on this change to marvell. We don't want mrvl
documented.

> - st-ericsson: duplicates "ste" _and_ "stericsson"

We should make it clear which one is preferred. If there are a bunch
of cases, then we should document and mark deprecated. If there are
only a few, I would leave undocumented.

> - pci8086: seems to be a unfortunate alias for "intel"
> - pnpPNP: used on PowerPC?

I believe these are special cases where the vendor and product IDs are
used to form the compatible strings.

>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Thanks for fixing these and in particular my failure to document Calxeda. :)

Applied for 3.15.

Rob

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 40ce2df..b5e7485 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -3,6 +3,7 @@ Device tree binding vendor prefix registry.  Keep list in alphabetical order.
>  This isn't an exhaustive list, but you should add new prefixes to it before
>  using them to avoid name-space collisions.
>
> +abilis Abilis Systems
>  active-semi    Active-Semi International Inc
>  ad     Avionic Design GmbH
>  adi    Analog Devices, Inc.
> @@ -11,14 +12,17 @@ ak  Asahi Kasei Corp.
>  allwinner      Allwinner Technology Co., Ltd.
>  altr   Altera Corp.
>  amcc   Applied Micro Circuits Corporation (APM, formally AMCC)
> +amd    Advanced Micro Devices (AMD), Inc.
>  amstaos        AMS-Taos Inc.
>  apm    Applied Micro Circuits Corporation (APM)
>  arm    ARM Ltd.
> +armadeus       ARMadeus Systems SARL
>  atmel  Atmel Corporation
>  auo    AU Optronics Corporation
>  avago  Avago Technologies
>  bosch  Bosch Sensortec GmbH
>  brcm   Broadcom Corporation
> +calxeda        Calxeda
>  capella        Capella Microsystems, Inc
>  cavium Cavium, Inc.
>  cdns   Cadence Design Systems Inc.
> @@ -26,8 +30,10 @@ chrp Common Hardware Reference Platform
>  chunghwa       Chunghwa Picture Tubes Ltd.
>  cirrus Cirrus Logic, Inc.
>  cortina        Cortina Systems, Inc.
> +crystalfontz   Crystalfontz America, Inc.
>  dallas Maxim Integrated Products (formerly Dallas Semiconductor)
>  davicom        DAVICOM Semiconductor, Inc.
> +dlink  D-Link Systems, Inc.
>  denx   Denx Software Engineering
>  edt    Emerging Display Technologies
>  emmicro        EM Microelectronic
> @@ -37,7 +43,9 @@ est   ESTeem Wireless Modems
>  fsl    Freescale Semiconductor
>  GEFanuc        GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>  gef    GE Fanuc Intelligent Platforms Embedded Systems, Inc.
> +globalscale    Globalscale Technologies, Inc.
>  gmt    Global Mixed-mode Technology, Inc.
> +google Google, Inc.
>  gumstix        Gumstix, Inc.
>  haoyu  Haoyu Microelectronic Co. Ltd.
>  hisilicon      Hisilicon Limited.
> @@ -46,9 +54,12 @@ hp   Hewlett Packard
>  ibm    International Business Machines (IBM)
>  idt    Integrated Device Technologies, Inc.
>  img    Imagination Technologies Ltd.
> +intel  Intel Corporation
>  intercontrol   Inter Control Group
>  isl    Intersil
>  karo   Ka-Ro electronics GmbH
> +lacie  LaCie
> +lantiq Lantiq Semiconductor
>  lg     LG Corporation
>  linux  Linux-specific binding
>  lsi    LSI Corp. (LSI Logic)
> @@ -56,12 +67,16 @@ marvell     Marvell Technology Group Ltd.
>  maxim  Maxim Integrated Products
>  microchip      Microchip Technology Inc.
>  mosaixtech     Mosaix Technologies, Inc.
> +moxa   Moxa
>  national       National Semiconductor
>  neonode                Neonode Inc.
> +netgear        NETGEAR
>  nintendo       Nintendo
> +nokia  Nokia
>  nvidia NVIDIA
>  nxp    NXP Semiconductors
>  onnn   ON Semiconductor Corp.
> +opencores      OpenCores.org
>  panasonic      Panasonic Corporation
>  phytec PHYTEC Messtechnik GmbH
>  picochip       Picochip Ltd
> @@ -94,4 +109,5 @@ via  VIA Technologies, Inc.
>  winbond Winbond Electronics corp.
>  wlf    Wolfson Microelectronics
>  wm     Wondermedia Technologies, Inc.
> +xes    Extreme Engineering Solutions (X-ES)
>  xlnx   Xilinx
> --
> 1.8.5.3
>
