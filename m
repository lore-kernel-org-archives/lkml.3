Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaITEeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 00:34:44 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58353 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaITEem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 00:34:42 -0400
Date: Fri, 19 Sep 2014 21:34:38 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, "Dmitriy B." <rzk333@gmail.com>,
        Yassin Jaffer <yassinjaffer@gmail.com>, Jonas Meyer <quitte@gmail.com>
Subject: Re: [PATCH v4 0/2] mtd: nand: add sunxi NAND flash controller support
Message-ID: <20140920043438.GD8127@brian-ubuntu>
References: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Mon, Aug 18, 2014 at 07:26:26PM +0200, Boris BREZILLON wrote:
> This patch series adds support for the sunxi NAND Flash Controller (NFC)
> block.
> 
> These two patches only add support for the basic NAND stuff:
>  - NAND controller operations
>  - SW and HW ECC handling (with both syndrome and normal ECC scheme)
> 
> If you want support for advanced features you can find it on my github
> repo [1]:
>  - HW randomization support
>  - per partition ECC/Randomizer to handle bootloader partitions
> 
> DMA transfers are not supported yet, but I have reworked the OOB layout
> when using the HW ECC scheme to match the one used when accessing the NAND
> with DMA transfers (the available OOB bytes are placed at the end of the
> OOB area).
> 
> This patch series depends on this other one [2] which adds support for ONFI
> timing mode retrieval on non-ONFI NANDs.

Were you planning to send v2 of your series [2]? I see you made a
mistake you were planning on fixing:

  https://lkml.org/lkml/2014/7/30/423

Brian

> Best Regards,
> 
> Boris
> 
> [1]https://github.com/bbrezillon/linux-sunxi/tree/sunxi-nand-v4
> [2]https://lkml.org/lkml/2014/7/28/156
> 
> Changes since v3:
>  - removed nand core code modifications from the patch series (submitted
>    separately)
>  - added documentation to the code
>  - forced timeout (a default timeout is used when none is provided by the
>    caller) on controller operations
>  - fixed coding style issues
>  - removed unneeded irq field from the sunxi_nfc struct
>  - fixed several memory leaks
>  - reworked the NFC reset code (to avoid potential garbage config from the
>    bootloader)
>  - made use of ECC_EXCEPTION flag to prevent erased page from generating
>    ECC errors
>  - changed the OOB layout for HW ECC scheme
> 
> Changes since v2:
>  - merge HW ECC implementation in base implementation patch
>  - fix timing config when interfacing with an ONFI compatible chip
> 
> Changes since v1:
>  - add HW ECC support
>  - rework NAND timings retrieval (use ONFI timing mode instead of raw timings)
>  - add nand-ecc-level property to specify NAND ECC requirements from DT
> 
> Boris BREZILLON (2):
>   mtd: nand: add sunxi NAND flash controller support
>   mtd: nand: add sunxi NFC dt bindings doc
> 
>  .../devicetree/bindings/mtd/sunxi-nand.txt         |   45 +
>  drivers/mtd/nand/Kconfig                           |    6 +
>  drivers/mtd/nand/Makefile                          |    1 +
>  drivers/mtd/nand/sunxi_nand.c                      | 1362 ++++++++++++++++++++
>  4 files changed, 1414 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
>  create mode 100644 drivers/mtd/nand/sunxi_nand.c
> 
