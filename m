Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaGNH6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:58:48 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36199 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaGNH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:58:41 -0400
Date: Mon, 14 Jul 2014 08:58:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, kernel@stlinux.com
Subject: Re: [PATCH v3+1 5/5] ARM: DT: STi: STiH416: Add DT node for MiPHY365x
Message-ID: <20140714075835.GJ2954@lee--X1>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <1404906074-31992-6-git-send-email-lee.jones@linaro.org>
 <20140711115406.GB2954@lee--X1>
 <53C0819E.4000202@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C0819E.4000202@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014, Sergei Shtylyov wrote:

> Hello.
> 
> On 07/11/2014 03:54 PM, Lee Jones wrote:
> 
> >The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> >devices. It has 2 ports which it can use for either; both SATA, both
> >PCIe or one of each in any configuration.
> 
> >Acked-by: Mark Rutland <mark.rutland@arm.com>
> >Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> >diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
> >index 4e2df66..c3c2ac6 100644
> >--- a/arch/arm/boot/dts/stih416-b2020.dts
> >+++ b/arch/arm/boot/dts/stih416-b2020.dts
> >@@ -12,4 +12,16 @@
> >  / {
> >  	model = "STiH416 B2020";
> >  	compatible = "st,stih416-b2020", "st,stih416";
> >+
> >+	soc {
> >+		miphy365x_phy: miphy365x@fe382000 {
> >+			phy_port0: port@fe382000 {
> 
>    I don't understand why are you creating the duplicate labels;
> doesn't 'dtc' complain about them?

I've never seen dtc complain about this:

  DTC     arch/arm/boot/dts/dra72-evm.dtb
  DTC     arch/arm/boot/dts/stih407-b2120.dtb
  DTC     arch/arm/boot/dts/stih415-b2000.dtb
  DTC     arch/arm/boot/dts/stih415-b2020.dtb
  DTC     arch/arm/boot/dts/stih416-b2000.dtb
  DTC     arch/arm/boot/dts/stih416-b2020.dtb
  DTC     arch/arm/boot/dts/stih416-b2020e.dtb
  DTC     arch/arm/boot/dts/armada-375-db.dtb

Probably because they're not actually 'duplicate' per say.  Rather
they are the same node split into different files.  I can remove the
labels if required though.

> You could instead refer to them
> as:
> 
> &miphy365x_phy {
> };

I dislike this formatting.  I find it convolutes the hierarchical
structure and makes DTS (and some DTSI) files hard to read i.e hides
parenthood etc.

[...]

> >+		miphy365x_phy: miphy365x@fe382000 {
> 
>    The ePAPR standard [1] says:
> 
> The name of a node should be somewhat generic, reflecting the
> function of the device and not its precise programming model.

Good point.  Will change to 'phy'.

> >+			compatible      = "st,miphy365x-phy";
> >+			st,syscfg  	= <&syscfg_rear>;
> >+			#address-cells	= <1>;
> >+			#size-cells	= <1>;
> >+			ranges;
> >+
> >+			phy_port0: port@fe382000 {
> >+				#phy-cells = <1>;
> 
>    If these are PHY devices, they should be named "phy", not "port".

Then what do you call the parent node?

I see it as:

phy {
        port {
        };
};

Or 

phy {
    channel {
    };
};

What does Kishon think?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
