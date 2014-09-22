Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaIVSfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:35:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55264 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaIVSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:35:40 -0400
Date: Mon, 22 Sep 2014 11:35:36 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Yassin Jaffer <yassinjaffer@gmail.com>
Subject: Re: [PATCH v3 1/2] mtd: nand: support ONFI timing mode retrieval for
 non-ONFI NANDs
Message-ID: <20140922183536.GQ1193@ld-irv-0074>
References: <1411409511-4381-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411409511-4381-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411409511-4381-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index b7c1199..b0b74cc 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -587,6 +587,11 @@ struct nand_buffers {
>   * @ecc_step_ds:	[INTERN] ECC step required by the @ecc_strength_ds,
>   *                      also from the datasheet. It is the recommended ECC step
>   *			size, if known; if unknown, set to zero.
> + * @onfi_timing_mode_default: [INTERN] default ONFI timing mode. This field is
> + *			      either deduced from the datasheet if the NAND
> + *			      chip is not ONFI compliant or set to 0 if it is
> + *			      (an ONFI chip is always configured in mode 0
> + *			      after a NAND reset)

This is probably OK only if every NAND chip is at least as fast as ONFI
mode 0. For older / legacy flash, I'm not sure if that's 100% true.
Maybe we'll need an UNKNOWN value, for those whose timing information is
not known?

Anyway, I think this is OK for now. Pushed the series to l2-mtd.git.
Thanks!

>   * @numchips:		[INTERN] number of physical chips
>   * @chipsize:		[INTERN] the size of one chip for multichip arrays
>   * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1

Brian
