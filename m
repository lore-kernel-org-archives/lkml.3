Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaGKOWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:22:13 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35781 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaGKOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:39 -0400
Date: Fri, 11 Jul 2014 11:13:58 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 05/13] thermal: rcar: Document SoC-specific bindings
Message-ID: <20140711091358.GK12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-6-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404908623-909-6-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:23:35PM +0200, Geert Uytterhoeven wrote:
> The documentation only mentioned the generic fallback compatible property.
> Add the missing SoC-specific compatible properties, some of which are
> already in use.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: linux-pm@vger.kernel.org

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  .../devicetree/bindings/thermal/rcar-thermal.txt       | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> index 28ef498a66e5..0ef00be44b01 100644
> --- a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
> @@ -1,7 +1,13 @@
>  * Renesas R-Car Thermal
>  
>  Required properties:
> -- compatible		: "renesas,rcar-thermal"
> +- compatible		: "renesas,thermal-<soctype>", "renesas,rcar-thermal"
> +			  as fallback.
> +			  Examples with soctypes are:
> +			    - "renesas,thermal-r8a73a4" (R-Mobile AP6)
> +			    - "renesas,thermal-r8a7779" (R-Car H1)
> +			    - "renesas,thermal-r8a7790" (R-Car H2)
> +			    - "renesas,thermal-r8a7791" (R-Car M2)
>  - reg			: Address range of the thermal registers.
>  			  The 1st reg will be recognized as common register
>  			  if it has "interrupts".
> @@ -12,18 +18,18 @@ Option properties:
>  
>  Example (non interrupt support):
>  
> -thermal@e61f0100 {
> -	compatible = "renesas,rcar-thermal";
> -	reg = <0xe61f0100 0x38>;
> +thermal@ffc48000 {
> +	compatible = "renesas,thermal-r8a7779", "renesas,rcar-thermal";
> +	reg = <0xffc48000 0x38>;
>  };
>  
>  Example (interrupt support):
>  
>  thermal@e61f0000 {
> -	compatible = "renesas,rcar-thermal";
> +	compatible = "renesas,thermal-r8a73a4", "renesas,rcar-thermal";
>  	reg = <0xe61f0000 0x14
>  		0xe61f0100 0x38
>  		0xe61f0200 0x38
>  		0xe61f0300 0x38>;
> -	interrupts = <0 69 4>;
> +	interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>;
>  };
> -- 
> 1.9.1
> 
