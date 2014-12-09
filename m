Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbaLIOy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:54:59 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44133 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaLIOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:54:58 -0500
Date: Tue, 9 Dec 2014 14:54:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, computersforpeace@gmail.com, pekon@pek-sem.com,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v4 00/11] mtd: nand: Support for new DT NAND driver
Message-ID: <20141209145450.GB3951@x1>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014, Lee Jones wrote:

> Hi Brian,
>   
> I believe all of your queries have either been answered or addressed
> and I am hoping this will be the last submission [v2]. :)
> 
> This is v4 of the squashed submission.  v1 had a small typo which
> prevented the BBT code from being truly configurable, v2 had some
> build issues due to a silly 'post testing' fixup mistake and v3
> suffered with some checkpatch errors which have been rectified and
> some unused/utilised code segments which have now been removed.
> I've also fixed some DMA issues which you spotted and provided a
> more suitable ECC tolerance, which has been coupled with a comment
> which describes our reasons for not taking the OOB area into
> consideration during this operation.
>   
> Also:
>   
>   Builds        Pass
>   Smatch        Pass
>   Sparse        Pass
>   Bisectability Pass
>   NAND Test     Pass
>   UBI Tests     Pass
>   MTD Tests     Pass (accept OOB test which is not applicable with
>                       this controller.  I will rectify this in the
>                       near future though, as it _can be_ useful for
>                       debugging/testing.)

7 week poke.

> Lee Jones (11):
>   ARM: multi-v7: Enable ST BCH NAND
>   ARM: sti: Add two new clock definitions for use with ST's NAND
>     controllers
>   ARM: sti: Add BCH (NAND Flash) Controller support for STiH41x (Orly)
>     SoCs
>   ARM: sti: Enable BCH NAND for STiH416 B2020-RevE
>   mtd: nand: Add new generic NAND Device Tree property
>     'nand-chip-select'
>   mtd: nand: WARN() if EEC Bytes per page is larger than the OOB
>   mtd: nand: stm_nand_bch: provide Device Tree documentation
>   mtd: nand: stm_nand_bch: add shared register defines for ST's NAND
>     Controller drivers
>   mtd: nand: stm_nand_bch: adding BBT header
>   mtd: nand: stm_nand_bch: add support for ST's BCH NAND controller
>   mtd: nand: stm_nand_bch: provide ST's implementation of Bad Block
>     Table
> 
>  Documentation/devicetree/bindings/mtd/nand.txt     |    3 +
>  Documentation/devicetree/bindings/mtd/stm-nand.txt |   74 +
>  arch/arm/boot/dts/stih416-b2020e.dts               |    8 +
>  arch/arm/boot/dts/stih41x-b2020.dtsi               |   35 +
>  arch/arm/configs/multi_v7_defconfig                |    2 +
>  drivers/mtd/nand/Kconfig                           |   15 +
>  drivers/mtd/nand/Makefile                          |    3 +
>  drivers/mtd/nand/nand_base.c                       |    2 +
>  drivers/mtd/nand/stm_nand_bbt.c                    |  619 ++++++++
>  drivers/mtd/nand/stm_nand_bch.c                    | 1645 ++++++++++++++++++++
>  drivers/mtd/nand/stm_nand_regs.h                   |  304 ++++
>  include/dt-bindings/clock/stih416-clks.h           |    2 +
>  include/linux/mtd/stm_nand.h                       |  131 ++
>  include/linux/mtd/stm_nand_bbt.h                   |   22 +
>  14 files changed, 2865 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt
>  create mode 100644 drivers/mtd/nand/stm_nand_bbt.c
>  create mode 100644 drivers/mtd/nand/stm_nand_bch.c
>  create mode 100644 drivers/mtd/nand/stm_nand_regs.h
>  create mode 100644 include/linux/mtd/stm_nand.h
>  create mode 100644 include/linux/mtd/stm_nand_bbt.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
