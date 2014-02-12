Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaBLTuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:50:37 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49936 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaBLTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 12 Feb 2014 11:49:55 -0800
Message-ID: <CAGVrzcZei92K9Jeue-Yvcev7n08YEEqfRbN2xgqLpW7epMzFVA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mtd: nand: add per partition ECC config
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gupta Pekon <pekon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

2014-02-11 13:46 GMT-08:00 Boris BREZILLON <b.brezillon.dev@gmail.com>:
> Hello,
>
> This patch series is a proposal to add per partition ECC config.
>
> It defines a new partition type called nand_part which stores a pointer to
> a nand_ecc_ctrl struct.
> This specific nand_ecc_ctrl struct is used in place of the base NAND chip
> nand_ecc_ctrl struct when accessing NAND chip from nand_part MTD device.
>
> If the partition does not define any ECC config, the NAND chip ECC config
> is used instead.

Although the idea does look nice on the paper, I wonder if it is
really useful to have that much complexity in the kernel. Most likely
what is happening is that your bootloader partition has a specific ECC
scheme due to the CPU bootrom or whatever early bootagent is running
on the system. When that is the case, this can be solved in user-space
by preparing full pages (main+spare) along with their specific ECC
requirements and use the MTD_FILE_MODE_RAW option on your specific MTD
partition.

You do not describe what is the end goal of this patchset, which might
help figuring out the potential other platforms requirements etc...

>
> This patch series also provides an helper function to parse DT defined NAND
> partitions (ofnandpart_parse).
>
> If you want to test it you'll have to replace calls to
> mtd_device_parse_register with ofnandpart_parse within your NAND controller
> driver and implement a driver specific parser function that will provide
> the ECC config (see ofnandpart_data struct).
>
> The 4th patch of this series is here as an example on how to move from MTD
> partitions to NAND partitions.
>
> Best Regards,
>
> Boris
>
> Changes since v1:
> - almost everything :-)
>
> Boris BREZILLON (4):
>   mtd: nand: take nand_ecc_ctrl initialization out of nand_scan_tail
>   mtd: nand: add support for NAND partitions
>   mtd: nand: add DT NAND partition parser
>   mtd: nand: add NAND partition support to the sunxi driver
>
>  drivers/mtd/nand/Kconfig      |    4 +
>  drivers/mtd/nand/Makefile     |    2 +
>  drivers/mtd/nand/nand_base.c  |  763 ++++++++++++++++++++++++++++++++---------
>  drivers/mtd/nand/ofnandpart.c |  104 ++++++
>  drivers/mtd/nand/sunxi_nand.c |   69 +++-
>  include/linux/mtd/nand.h      |   54 +++
>  6 files changed, 835 insertions(+), 161 deletions(-)
>  create mode 100644 drivers/mtd/nand/ofnandpart.c
>
> --
> 1.7.9.5
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/



-- 
Florian
