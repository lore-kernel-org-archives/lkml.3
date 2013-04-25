Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3DYGcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:32:15 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:40001 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3DYGcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <1366707297-31309-2-git-send-email-b32955@freescale.com>
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>
	<1366707297-31309-2-git-send-email-b32955@freescale.com>
Date: Wed, 24 Apr 2013 23:32:12 -0700
Message-ID: <CAN8TOE-oy=74kSKrnxG+Ve4qZfrwEYbvh6hGGquTyLu6T+UbSA@mail.gmail.com>
Subject: Re: [PATCH V3 1/9] mtd: add more comment for ecc_strength/ecc_size
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would recommend different wording, describing what they represent
rather than how we accomplish it. See below.

On Tue, Apr 23, 2013 at 1:54 AM, Huang Shijie <b32955@freescale.com> wrote:
> Add more commit for ecc_strength and ecc_size fields.
> We can treat the comment as the initial semantics for the two fields.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  include/linux/mtd/nand.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 5458021..c1cc690 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -436,7 +436,9 @@ struct nand_buffers {
>   * @cellinfo:          [INTERN] MLC/multichip data from chip ident
>   * @ecc_strength:      [INTERN] ECC correctability from the datasheet.

How about just: "minimum number of bits correctability, if known; if
unknown, set to 0

>   * @ecc_size:          [INTERN] ECC size required by the @ecc_strength,
> - *                      also from the datasheet.
> + *                      also from the datasheet. If we do not know the
> + *                     @ecc_size and @ecc_strength of the nand chips, we can
> + *                     set zeros to them which are the default value.

"recommend ECC step size, if known; if unknown, set to 0"

>   * @numchips:          [INTERN] number of physical chips
>   * @chipsize:          [INTERN] the size of one chip for multichip arrays
>   * @pagemask:          [INTERN] page number mask = number of (pages / chip) - 1

Brian
