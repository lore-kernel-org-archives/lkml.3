Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaKFDFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:05:51 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34263 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKFDFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
Date: Thu, 6 Nov 2014 11:05:46 +0800
Message-ID: <CAN1soZzW8UgHsqR89jKswbjkm9cO-LXUEQ+svc=68+A_avj0hw@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] mtd: hisilicon: add a new driver for NAND
 controller of hisilicon hip04 Soc
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        caizhiyong@huawei.com, "xuwei (O)" <xuwei5@hisilicon.com>,
        wangzhou1@hisilicon.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 8:46 PM, Zhou Wang <wangzhou.bry@gmail.com> wrote:
> This patchset adds the support for NAND controller of hisilicon hip04 Soc.
> The NAND controller IP was developed by hisilicon and needs a new driver to
> support it. This patchset is based on v3.18-rc1. I have tested that NAND flash
> controller works fine in Hip04 D01 board.
>
> Changes in v4:
> - add mtd->dev.parent = &pdev->dev, thanks Frans Klaver.
> Changes in v3:
> - Modify code to eliminate some code style warnings.
> - add ecc-bits input check.
> - avoid using waterfall style in hisi_nfc_cmdfunc().
> Changes in v2:
> - Remove the patch for device tree, now patchset only has the driver and its
>   device tree binding documentation.
> - Change the file name: hisi_nand.c to hisi504_nand.c.
> Changes in v1:
> - Remove callback functions out of struct hinfc_host, and call them directly
>   in relative functions.
> - Change hinfc_read and hinfc_write from macros to inline functions.
> - Instead of putting pointers, embed struct nand_chip and struct mtd_info in
>   struct hinfc_host directly.
> - rewrite some unclear lines in device tree binding document, correct some
>   code style error.
>
> Link on v3:
> - https://lkml.org/lkml/2014/10/28/386
> Link on v2:
> - https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg750071.html
> Link on v1:
> - https://lkml.org/lkml/2014/7/15/198
>
> Zhou Wang (2):
>   mtd: hisilicon: add a new NAND controller driver for hisilicon hip04 Soc
>   mtd: hisilicon: add device tree binding documentation
>
>  .../devicetree/bindings/mtd/hisi504-nand.txt       |   40 +
>  drivers/mtd/nand/Kconfig                           |    5 +
>  drivers/mtd/nand/Makefile                          |    1 +
>  drivers/mtd/nand/hisi504_nand.c                    |  846 ++++++++++++++++++++
>  4 files changed, 892 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/hisi504-nand.txt
>  create mode 100644 drivers/mtd/nand/hisi504_nand.c
>
> --
> 1.7.9.5
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
