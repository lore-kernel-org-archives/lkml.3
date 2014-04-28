Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbaD1QMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:12:34 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:38430 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaD1QMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:12:31 -0400
Date: Mon, 28 Apr 2014 13:10:41 -0300
From: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
To: George Cherian <george.cherian@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, bcousson@baylibre.com,
        tony@atomide.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH 1/4] ARM: dts: am335x-bone-common: use phandles for USB
 and DMA refs
Message-ID: <20140428161041.GA6140@solid>
References: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
 <535E689D.7010204@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535E689D.7010204@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:11:33PM +0530, George Cherian wrote:
> On 4/28/2014 7:28 PM, Guido Martínez wrote:
> >Use phandles instead of unit adresses to reference usb and dma nodes.
> >This makes the DT more robust and readable.
> The series will give dtb build errors
> Error: arch/arm/boot/dts/am335x-bone-common.dtsi:186.2-15 syntax error
> FATAL ERROR: Unable to parse input tree
> Error: arch/arm/boot/dts/am335x-evmsk.dts:367.2-15 syntax error
> FATAL ERROR: Unable to parse input tree
> make[1]: *** [arch/arm/boot/dts/am335x-bone.dtb] Error 1
> make[1]: *** Waiting for unfinished jobs....
> Error: arch/arm/boot/dts/am335x-evm.dts:334.2-15 syntax error
> FATAL ERROR: Unable to parse input tree
> make[1]: *** [arch/arm/boot/dts/am335x-evmsk.dtb] Error 1
> make[1]: *** [arch/arm/boot/dts/am335x-evm.dtb] Error 1
> Error: arch/arm/boot/dts/am335x-igep0033.dtsi:204.2-15 syntax error
> FATAL ERROR: Unable to parse input tree
> make[1]: *** [arch/arm/boot/dts/am335x-base0033.dtb] Error 1
> Error: arch/arm/boot/dts/am335x-bone-common.dtsi:186.2-15 syntax error
> FATAL ERROR: Unable to parse input tree
> make[1]: *** [arch/arm/boot/dts/am335x-boneblack.dtb] Error 1
> make: *** [dtbs] Error 2
> 
Terribly sorry about this. I'll send a v2.

> >
> >Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
> >---
> >  arch/arm/boot/dts/am335x-bone-common.dtsi | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> >diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> >index 2e7d932..b95bc9a 100644
> >--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> >+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> >@@ -183,28 +183,28 @@
> >  &usb {
> >  	status = "okay";
> >-	control@44e10620 {
> >+	&usb_ctrl_mod {
> >  		status = "okay";
> >  	};
> >-	usb-phy@47401300 {
> >+	&usb0_phy {
> >  		status = "okay";
> >  	};
> >-	usb-phy@47401b00 {
> >+	&usb1_phy {
> >  		status = "okay";
> >  	};
> >-	usb@47401000 {
> >+	&usb0 {
> >  		status = "okay";
> >  	};
> >-	usb@47401800 {
> >+	&usb1 {
> >  		status = "okay";
> >  		dr_mode = "host";
> >  	};
> >-	dma-controller@47402000  {
> >+	&cppi41dma  {
> >  		status = "okay";
> >  	};
> >  };
> Instead the patch should be
> 
>      diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi
> b/arch/arm/boot/dts/am335x-bone-common.dtsi
>      index 2e7d932..06be20a 100644
>      --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
>      +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
>      @@ -182,31 +182,30 @@
> 
>       &usb {
>              status = "okay";
>      +};
>      +&usb_ctrl_mod {
>      +       status = "okay";
>      +};
> 
>      -       control@44e10620 {
>      -               status = "okay";
>      -       };
>      -
>      -       usb-phy@47401300 {
>      -               status = "okay";
>      -       };
>      +&usb0_phy {
>      +       status = "okay";
>      +};
> 
>      -       usb-phy@47401b00 {
>      -               status = "okay";
>      -       };
>      +&usb1_phy {
>      +       status = "okay";
>      +};
> 
>      -       usb@47401000 {
>      -               status = "okay";
>      -       };
>      +&usb {
>      +       status = "okay";
>      +};
> 
>      -       usb@47401800 {
>      -               status = "okay";
>      -               dr_mode = "host";
>      -       };
>      +&usb1 {
>      +       status = "okay";
>      +       dr_mode = "host";
>      +};
> 
>      -       dma-controller@47402000  {
>      -               status = "okay";
>      -       };
>      +&cppi41dma  {
>      +       status = "okay";
>       };
> 
> 
> 
> -- 
> -George
> 

-- 
Guido Martínez, VanguardiaSur
www.vanguardiasur.com.ar
