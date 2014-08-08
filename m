Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaHHBa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:30:27 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46305 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbaHHBa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:30:26 -0400
Message-ID: <53E4282F.7000403@boundarydevices.com>
Date: Thu, 07 Aug 2014 18:30:23 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
References: <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>	<20140626151424.GT32514@n2100.arm.linux.org.uk>	<20140627112151.GF32514@n2100.arm.linux.org.uk>	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>	<20140627163108.GP32514@n2100.arm.linux.org.uk>	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>	<20140806095012.GN30282@n2100.arm.linux.org.uk>	<C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>	<20140806125550.GO30282@n2100.arm.linux.org.uk>	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>	<20140807121248.GY30282@n2100.arm.linux.org.uk>	<CAOMZO5ACj6ER3tUMS8XsnigT=-zs4TZFmobbtmTN-+LWJFLt4Q@mail.gmail.com> <CAOMZO5BZdnzOuD9CcMv3bXsryT-j1A_bAjF6EAj_=BQTuxn45A@mail.gmail.com>
In-Reply-To: <CAOMZO5BZdnzOuD9CcMv3bXsryT-j1A_bAjF6EAj_=BQTuxn45A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2014 7:38 AM, Fabio Estevam wrote:
> On Thu, Aug 7, 2014 at 11:20 AM, Fabio Estevam <festevam@gmail.com> wrote:
> 
> ,but I am wondering if we should also do:
> 
> --- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> @@ -66,6 +66,7 @@
>         pinctrl-0 = <&pinctrl_enet>;
>         phy-mode = "rgmii";
>         interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
> +                             <&intc 0 118 IRQ_TYPE_LEVEL_HIGH>,
>                               <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
>         status = "okay";
>  };
> @@ -226,7 +227,7 @@
>                                 MX6QDL_PAD_RGMII_RD2__RGMII_RD2         0x1b0b0
>                                 MX6QDL_PAD_RGMII_RD3__RGMII_RD3         0x1b0b0
>                                 MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL   0x1b0b0
> -                               MX6QDL_PAD_GPIO_6__ENET_IRQ             0x000b1
> +                               MX6QDL_PAD_GPIO_6__ENET_IRQ
>  0x400000b1
> 
> Since the Workaround for erratum ERR006687 states that the SION bit
> needs to be used:
> 
> "All of the interrupts can be selected by MUX and output to pad GPIO6.
> If GPIO6 is selected to
> output ENET interrupts and GPIO6 SION is set, the resulting GPIO
> interrupt will wake the system
> from Wait mode."
> 
arch/arm/boot/dts/imx6q-pinfunc.h:#define MX6QDL_PAD_GPIO_6__ENET_IRQ               0x230 0x600
0x03c 0x11 0xff000609

So, the ion bit should already be set(0x11). But the other way works too.


Troy
