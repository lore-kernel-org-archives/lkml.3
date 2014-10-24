Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbaJXLqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:46:14 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42161 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbaJXLqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <1414073085-19296-2-git-send-email-wangzhou.bry@gmail.com>
References: <1414073085-19296-1-git-send-email-wangzhou.bry@gmail.com>
	<1414073085-19296-2-git-send-email-wangzhou.bry@gmail.com>
Date: Fri, 24 Oct 2014 19:46:11 +0800
Message-ID: <CAN1soZz8NYxppaY4cXadqynERZ=6ZRAynDtptGAps+yUJZ0Qsw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mtd: hisilicon: add a new NAND controller driver
 for hisilicon hip04 Soc
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        Rob Herring <robh+dt@kernel.org>, galak@codeaurora.org,
        caizhiyong@huawei.com, "xuwei (O)" <xuwei5@hisilicon.com>,
        wangzhou1@hisilicon.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:04 PM, Zhou Wang <wangzhou.bry@gmail.com> wrote:
> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
> ---
>  drivers/mtd/nand/Kconfig        |    5 +
>  drivers/mtd/nand/Makefile       |    1 +
>  drivers/mtd/nand/hisi504_nand.c |  836 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 842 insertions(+)
>  create mode 100644 drivers/mtd/nand/hisi504_nand.c
>

I think that you need to run scripts/checkpatch.pl. There're some
warnings reported on this patch.

> +
> +       case NAND_CMD_SEQIN:
> +               host->offset = column;
> +

It's better not using waterfall style. Maybe you can write it clearly.
            case NAND_CMD_SEQIN:
                    host->offset = column;
                    set_addr(mtd, column, page_addr);
                    break;

> +       chip->ecc.mode = of_get_nand_ecc_mode(np);
> +       /* read ecc-bits from dts */
> +       of_property_read_u32(np, "hisi,nand-ecc-bits", &host->ecc_bits);

Do you need to check the ecc_bits at here? Maybe user inputed the
wrong ecc_bits in DTS.

Best Regards
Haojian
