Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3HGQM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:12:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34242 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab3HGQM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:12:57 -0400
Subject: Re: [PATCH v3 3/5] devicetree: create a separate binding description for sata_highbank
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com>
Date: Wed, 7 Aug 2013 11:13:04 -0500
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Content-Transfer-Encoding: 8BIT
Message-Id: <75318AE8-35C9-453A-AC56-824C8FADD635@codeaurora.org>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com> <1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2013, at 10:52 AM, Mark Langsdorf wrote:

> The Calxeda sata_highbank driver has been adding its descriptions to the
> ahci driver. Separate them properly.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> ---
> Changes from v2
> 	Fixed some indenting.
> Changes from v1
> 	None.
> 
> .../devicetree/bindings/ata/ahci-platform.txt      | 18 +++---------
> .../devicetree/bindings/ata/sata_highbank.txt      | 32 ++++++++++++++++++++++
> 2 files changed, 36 insertions(+), 14 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 3ec0c5c..89de156 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -4,27 +4,17 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
> Each SATA controller should have its own node.
> 
> Required properties:
> -- compatible        : compatible list, contains "calxeda,hb-ahci" or "snps,spear-ahci"
> +- compatible        : compatible list, contains "snps,spear-ahci"
> - interrupts        : <interrupt mapping for SATA IRQ>
> - reg               : <registers mapping>
> 
> Optional properties:
> -- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
> -			SATA port to a combophy and a lane within that
> -			combophy
> -- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
> -			which indicates that the driver supports SGPIO
> -			indicator lights using the indicated GPIOs
> -- calxeda,led-order : a u32 array that map port numbers to offsets within the
> -			SGPIO bitstream.
> - dma-coherent      : Present if dma operations are coherent
> 
> Example:
>         sata@ffe08000 {
> -		compatible = "calxeda,hb-ahci";
> -                reg = <0xffe08000 0x1000>;
> -                interrupts = <115>;
> -		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> -					&combophy0 2 &combophy0 3>;
> +		compatible = "snps,spear-ahci";
> +		reg = <0xffe08000 0x1000>;
> +		interrupts = <115>;
> 
>         };
> diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
> new file mode 100644
> index 0000000..1ac6d3d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
> @@ -0,0 +1,32 @@
> +* Calxeda AHCI SATA Controller
> +
> +SATA nodes are defined to describe on-chip Serial ATA controllers.
> +The Calxeda SATA controller mostly conforms to the AHCI interface
> +with some special extensions to add functionality.
> +Each SATA controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "calxeda,hb-ahci"
> +- interrupts        : <interrupt mapping for SATA IRQ>
> +- reg               : <registers mapping>
> +
> +Optional properties:
> +- dma-coherent      : Present if dma operations are coherent
> +- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
> +			SATA port to a combophy and a lane within that
> +			combophy
> +- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
> +			which indicates that the driver supports SGPIO
> +			indicator lights using the indicated GPIOs
> +- calxeda,led-order : a u32 array that map port numbers to offsets within the
> +			SGPIO bitstream.

nit: whitespace after :

> +
> +Example:
> +        sata@ffe08000 {
> +		compatible = "calxeda,hb-ahci";
> +		reg = <0xffe08000 0x1000>;
> +		interrupts = <115>;
> +		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> +					&combophy0 2 &combophy0 3>;
> +

Its probably good to show all optional props (dma-coherent, calxeda,sgpio-gpios, & calxeda,led-order) in the example.

> +        };
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

