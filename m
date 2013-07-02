Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3GBFrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:47:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45268 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab3GBFro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:47:44 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Tony Lindgren <tony@atomide.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: RE: linux-next: manual merge of the arm-soc tree with the l2-mtd
 tree
Thread-Topic: linux-next: manual merge of the arm-soc tree with the l2-mtd
 tree
Thread-Index: AQHOduU2dcpaTOKd5UeUjh6prs+vjZlQ3XWQ
Date: Tue, 2 Jul 2013 05:44:25 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9E3BF5@DBDE04.ent.ti.com>
References: <20130702152954.f25bbf51c1a79aa4437e22ee@canb.auug.org.au>
In-Reply-To: <20130702152954.f25bbf51c1a79aa4437e22ee@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> Documentation/devicetree/bindings/mtd/gpmc-nand.txt between commits
> 6c88058ef927 ("ARM: OMAP2+: cleaned-up DT support of various ECC
> schemes") and 212012138deb ("mtd: nand: omap2: updated support for
> BCH4
> ECC scheme") from the l2-mtd tree and commit 496c8a0bbb72 ("ARM:
> OMAP2+:
> Allow NAND transfer mode to be specified in DT") from the arm-soc tree.
> 
> I fixed it up (maybe - see below) and can carry the fix as necessary (no
> action is required).
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
Yes following merge is correct. Apologies, as there were multiple OMAP2 NAND and GPMC updates and clean-up going into different trees, so these conflict came. Going forward you shouldn't find such issues, as code is more stable now. Thanks for help.

with regards, pekon

> diff --cc Documentation/devicetree/bindings/mtd/gpmc-nand.txt
> index b3f23df,df338cb..0000000
> --- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
> @@@ -17,59 -17,27 +17,66 @@@ Required properties
> 
>   Optional properties:
> 
>  - - nand-bus-width: 		Set this numeric value to 16 if the hardware
>  -				is wired that way. If not specified, a bus
>  -				width of 8 is assumed.
>  + - nand-bus-width: 		Determines data-width of the connected
> device
>  +				x16 = "16"
>  +				x8  = "8" (default)
> 
>  - - ti,nand-ecc-opt:		A string setting the ECC layout to use. One of:
> 
>  -		"sw"		Software method (default)
>  -		"hw"		Hardware method
>  -		"hw-romcode"	gpmc hamming mode method & romcode
> layout
>  -		"bch4"		4-bit BCH ecc code
>  -		"bch8"		8-bit BCH ecc code
>  + - ti,nand-ecc-opt:		Determines the ECC scheme used by driver.
>  +				It can be any of the following strings:
>  +
>  +	"hamming_code_sw"		1-bit Hamming ECC
>  +					- ECC calculation in software
>  +					- Error detection in software
>  +					- ECC layout compatible with S/W
> scheme
>  +
>  +	"hamming_code_hw"		1-bit Hamming ECC
>  +					- ECC calculation in hardware
>  +					- Error detection in software
>  +					- ECC layout compatible with S/W
> scheme
>  +
>  +	"hamming_code_hw_romcode"	1-bit Hamming ECC
>  +					- ECC calculation in hardware
>  +					- Error detection in software
>  +					- ECC layout compatible with ROM
> code
>  +
>  +	"bch4_code_hw_detection_sw"	4-bit BCH ECC
>  +					- ECC calculation in hardware
>  +					- Error detection in software
>  +					- ECC layout compatible with S/W
> scheme
>  +					* depends on
> CONFIG_MTD_NAND_ECC_BCH
>  +
>  +	"bch4_code_hw"             	4-bit BCH ECC
>  +					- ECC calculation in hardware
>  +					- Error detection in hardware
>  +					- ECC layout compatible with ROM
> code
>  +					* depends on
> CONFIG_MTD_NAND_OMAP_BCH
>  +					* requires <elm_id> to be specified
>  +
>  +	"bch8_code_hw_detection_sw"	8-bit BCH ECC
>  +					- ECC calculation in hardware
>  +					- Error detection in software
>  +					- ECC layout compatible with S/W
> scheme
>  +					* depends on
> CONFIG_MTD_NAND_ECC_BCH
>  +
>  +	"bch8_code_hw"             	8-bit BCH ECC
>  +					- ECC calculation in hardware
>  +					- Error detection in hardware
>  +					- ECC layout compatible with ROM
> code
>  +					* depends on
> CONFIG_MTD_NAND_OMAP_BCH
>  +					* requires <elm_id> to be specified
> 
> +  - ti,nand-xfer-type:		A string setting the data transfer type. One
> of:
> +
> + 		"prefetch-polled"	Prefetch polled mode (default)
> + 		"polled"		Polled mode, without prefetch
> + 		"prefetch-dma"		Prefetch enabled sDMA
> mode
> + 		"prefetch-irq"		Prefetch enabled irq mode
> +
>  - - elm_id:	Specifies elm device node. This is required to support BCH
>  - 		error correction using ELM module.
>  +
>  + - elm_id:			Specifies elm device node. This is required to
>  +				support some BCH ECC schemes mentioned
> above.
>  +
> 
>   For inline partiton table parsing (optional):
> 
