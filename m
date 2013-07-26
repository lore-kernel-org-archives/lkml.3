Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3GZPpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:45:22 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63884 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3GZPpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:45:18 -0400
Message-ID: <51F2998A.7070304@gmail.com>
Date: Fri, 26 Jul 2013 10:45:14 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com
Subject: Re: [PATCH 3/5] devicetree: create a separate binding description
 for sata_highbank
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com> <1374851518-4802-3-git-send-email-mark.langsdorf@calxeda.com>
In-Reply-To: <1374851518-4802-3-git-send-email-mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 10:11 AM, Mark Langsdorf wrote:
> The Calxeda sata_highbank driver has been adding its descriptions to the
> ahci driver. Separate them properly.
>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

> ---
>  .../devicetree/bindings/ata/ahci-platform.txt      | 14 ++--------
>  .../devicetree/bindings/ata/sata_highbank.txt      | 32 ++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 3ec0c5c..14d7b22 100644
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
> +		compatible = "snps,spear-ahci";
>                  reg = <0xffe08000 0x1000>;
>                  interrupts = <115>;
> -		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> -					&combophy0 2 &combophy0 3>;
>  
>          };
> diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
> new file mode 100644
> index 0000000..aa1b798
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
> +                reg = <0xffe08000 0x1000>;
> +                interrupts = <115>;
> +		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
> +					&combophy0 2 &combophy0 3>;
> +
> +        };
> 

