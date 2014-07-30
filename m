Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaG3O7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:59:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56253 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753334AbaG3O7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:59:15 -0400
Date: Wed, 30 Jul 2014 16:59:12 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mtd: nand: add Hynix's H27UCG8T2ATR-BC to nand_ids
 table
Message-ID: <20140730165912.74e81f4c@bbrezillon>
In-Reply-To: <1406539012-16320-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1406539012-16320-1-git-send-email-boris.brezillon@free-electrons.com>
	<1406539012-16320-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014 11:16:52 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Add the full description of the Hynix H27UCG8T2ATR-BC NAND chip in the
> nand_ids table so that we can later use the NAND ECC infos and ONFI timings
> mode in controller drivers.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/mtd/nand/nand_ids.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
> index 3d7c89f..19d4168 100644
> --- a/drivers/mtd/nand/nand_ids.c
> +++ b/drivers/mtd/nand/nand_ids.c
> @@ -46,6 +46,10 @@ struct nand_flash_dev nand_flash_ids[] = {
>  	{"SDTNRGAMA 64G 3.3V 8-bit",
>  		{ .id = {0x45, 0xde, 0x94, 0x93, 0x76, 0x50} },
>  		  SZ_16K, SZ_8K, SZ_4M, 0, 6, 1280, NAND_ECC_INFO(40, SZ_1K) },
> +	{"H27UCG8T2ATR-BC 64G 3.3V 8-bit",
> +		{ .id = {0xad, 0xde, 0x94, 0xda, 0x74, 0xc4} },
> +		  SZ_8K, SZ_8K, SZ_4M, 0, 6, 640, NAND_ECC_INFO(40, SZ_1K),

There is a big mistake here ------^

It should be SZ_2M not SZ_4M, I'll fix that.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
