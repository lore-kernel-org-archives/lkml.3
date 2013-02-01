Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3BAV7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:59:07 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:56170 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757371Ab3BAV7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:59:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+N7cjmcFUopJyFyGloqwvi
Date: Fri, 1 Feb 2013 13:58:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Philip Avinash <avinashphilip@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        artem.bityutskiy@linux.intel.com, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nsekhar@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH] ARM: OMAP: gpmc: Add device tree documentation for elm
 handle
Message-ID: <20130201215854.GW22517@atomide.com>
References: <1358485066-27495-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358485066-27495-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Philip Avinash <avinashphilip@ti.com> [130117 21:00]:
> In case ELM module available, omap2 NAND driver can opt for hardware
> correction method for bit flip errors in NAND flash with BCH. Hence the
> detection of ELM module is done through devicetree population of elm_id.
> This patch update device tree documentation for gpmc-nand for elm-id
> data population.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> This patch based [1] and depends on [2]. As Artem suggested, this patch can
> go in omap_tree due to the dependency on [3].
> Discussion can found at [4]
> 
> Tony,
>   Can you accept this patch.

Thanks applying into omap-for-v3.9/gpmc.

Regards,

Tony
 
> 1. http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=shortlog;h=refs/heads/omap-for-v3.9/gpmc
> 2. mtd: nand: omap2: Support for hardware BCH error correction
>    http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/576daed18c3f27bb5d0e57e1df11e8f7b493dce8
> 3. ARM: OMAP: gpmc: add DT bindings for GPMC timings and NAND
>    http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=commit;h=bc6b1e7b86f5d8e4a6fc1c0189e64bba4077efe0
> 4. https://lkml.org/lkml/2013/1/17/167   
> 
>  .../devicetree/bindings/mtd/gpmc-nand.txt          |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
> index 9f464f9..e7f8d7e 100644
> --- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
> @@ -29,6 +29,9 @@ Optional properties:
>  		"bch4"		4-bit BCH ecc code
>  		"bch8"		8-bit BCH ecc code
>  
> + - elm_id:	Specifies elm device node. This is required to support BCH
> + 		error correction using ELM module.
> +
>  For inline partiton table parsing (optional):
>  
>   - #address-cells: should be set to 1
> @@ -46,6 +49,7 @@ Example for an AM33xx board:
>  		#address-cells = <2>;
>  		#size-cells = <1>;
>  		ranges = <0 0 0x08000000 0x2000>;	/* CS0: NAND */
> +		elm_id = <&elm>;
>  
>  		nand@0,0 {
>  			reg = <0 0 0>; /* CS0, offset 0 */
> -- 
> 1.7.9.5
> 
