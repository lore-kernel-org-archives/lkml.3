Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3HHJqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:46:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60393 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964841Ab3HHJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:46:17 -0400
Date: Thu, 8 Aug 2013 10:46:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3 3/5] devicetree: create a separate binding
 description for sata_highbank
Message-ID: <20130808094608.GI14648@e106331-lin.cambridge.arm.com>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
 <1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 04:52:36PM +0100, Mark Langsdorf wrote:
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
>  .../devicetree/bindings/ata/ahci-platform.txt      | 18 +++---------
>  .../devicetree/bindings/ata/sata_highbank.txt      | 32 ++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 3ec0c5c..89de156 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -4,27 +4,17 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
>  Each SATA controller should have its own node.
>  
>  Required properties:
> -- compatible        : compatible list, contains "calxeda,hb-ahci" or "snps,spear-ahci"
> +- compatible        : compatible list, contains "snps,spear-ahci"
>  - interrupts        : <interrupt mapping for SATA IRQ>
>  - reg               : <registers mapping>
>  
>  Optional properties:
> -- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
> -			SATA port to a combophy and a lane within that
> -			combophy
> -- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
> -			which indicates that the driver supports SGPIO
> -			indicator lights using the indicated GPIOs
> -- calxeda,led-order : a u32 array that map port numbers to offsets within the
> -			SGPIO bitstream.
>  - dma-coherent      : Present if dma operations are coherent
>  
>  Example:
>          sata@ffe08000 {
> -		compatible = "calxeda,hb-ahci";
> -                reg = <0xffe08000 0x1000>;
> -                interrupts = <115>;
> -		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> -					&combophy0 2 &combophy0 3>;
> +		compatible = "snps,spear-ahci";
> +		reg = <0xffe08000 0x1000>;
> +		interrupts = <115>;
>  
>          };
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
> +
> +Example:
> +        sata@ffe08000 {
> +		compatible = "calxeda,hb-ahci";
> +		reg = <0xffe08000 0x1000>;
> +		interrupts = <115>;
> +		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> +					&combophy0 2 &combophy0 3>;
> +
> +        };

It would be nice to have examples for the remaining optional properties,
but otherwise:

Acked-by: Mark Rutland <mark.rutland@arm.com>
