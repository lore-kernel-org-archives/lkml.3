Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaCCTC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:02:58 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57357 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaCCTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:02:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+qTfr1sgzftpJFGNvBkq0a
Date: Mon, 3 Mar 2014 11:02:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, balbi@ti.com, george.cherian@ti.com, balajitk@ti.com,
        hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/12] phy: omap-control: Update DT binding information
Message-ID: <20140303190247.GD25804@atomide.com>
References: <1393859254-10937-1-git-send-email-rogerq@ti.com>
 <1393859254-10937-3-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393859254-10937-3-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140303 07:10]:
> Move omap-control binding information to the right location.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  Documentation/devicetree/bindings/phy/ti-phy.txt   | 25 ++++++++++++++++++++++
>  Documentation/devicetree/bindings/usb/omap-usb.txt | 24 ---------------------
>  2 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
> index 207e14c..41dc132 100644
> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
> @@ -1,5 +1,30 @@
>  TI PHY: DT DOCUMENTATION FOR PHYs in TI PLATFORMs
>  
> +OMAP CONTROL PHY
> +
> +Required properties:
> + - compatible: Should be one of
> + "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
> + "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
> +                        e.g. USB2_PHY on OMAP5.
> + "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
> +                        e.g. USB3 PHY and SATA PHY on OMAP5.
> + "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
> +                        DRA7 platform.
> + "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
> +                        AM437 platform.

To me it seems that you can leave out all the above. You can set these falgs
flags directly in the driver based on the compatible flag. Then just initialize
the .data in the driver based on the compatible flag.

> + - reg : Address and length of the register set for the device. It contains
> +   the address of "otghs_control" for control-phy-otghs or "power" register
> +   for other types.
> + - reg-names: should be "otghs_control" control-phy-otghs and "power" for
> +   other types.
> +
> +omap_control_usb: omap-control-usb@4a002300 {
> +        compatible = "ti,control-phy-otghs";
> +        reg = <0x4a00233c 0x4>;
> +        reg-names = "otghs_control";
> +};

Then you would instead have something like this:

	compatible = "ti,am347-control-phy-otghs";

That way you can initialize things without a need for custom bindings.

Regards,

Tony
