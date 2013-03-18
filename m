Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3CRHeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 03:34:36 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:50272 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3CRHee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 03:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <1363316461-10592-1-git-send-email-b32955@freescale.com>
References: <1363316461-10592-1-git-send-email-b32955@freescale.com>
Date: Mon, 18 Mar 2013 00:34:33 -0700
Message-ID: <CAN8TOE99=i_8-OsQYejme1dpgnRJGmPT=8PM+TSuHV5Nie+n7Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] mtd: use the full-id as the keyword for some nand chips
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 8:00 PM, Huang Shijie <b32955@freescale.com> wrote:
> As time goes on, we begin to meet the situation that we can not
> get enough information from some nand chips's id data.
> Take some Toshiba's nand chips for example.
> I have 4 Toshiba's nand chips in my hand:
>         TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2
>
> When we read these chips' datasheets, we will get the geometry of these chips:
>         TC58NVG2S0F : 4096 + 224
>         TC58NVG3S0F : 4096 + 232
>         TC58NVG5D2  : 8192 + 640
>         TC58NVG6D2  : 8192 + 640
>
> But we can not parse out the correct oob size for these chips from the id data.
> So it is time to add some new fields to the nand_flash_dev{},
> and update the detection mechanisms.
>
> v5 --> v6:
>         [1] add back the id_len as Brian's suggest.
>         [2] use id_len to check the full id nand or not.
>         [3] change the new fields oob_size/id_len to "uint16_t" type.
>         [4] misc
>
> v4 --> v5:
>         [1] remove the id_len field.
>         [2] based on Artem "mtd: nand: use more reasonable integer types"
>         [3] add more comments.
>
> v3 --> v4:
>         [1] rewrite the code based on the latest l2-mtd.
>         [2] add the full-id nand in the nand_flash_lds.
>
> v2 --> v3:
>         [1] remove the duplicated header.
>         [2] remove the field "ecc_len" in nand_flash_dev{}.
>         [3] fix some coding style warnings.
>         [4] add more comments
>
> Huang Shijie (3):
>   mtd: add new fields to nand_flash_dev{}
>   mtd: add the support to parse out the full-id nand type
>   mtd: add 4 Toshiba nand chips for the full-id case
>
>  drivers/mtd/nand/nand_base.c |   35 ++++++++++++++++++++++++++++++++---
>  drivers/mtd/nand/nand_ids.c  |   19 +++++++++++++++++++
>  include/linux/mtd/nand.h     |    4 ++++
>  3 files changed, 55 insertions(+), 3 deletions(-)

Series looks good to me. Thanks Huang!

Reviewed-by: Brian Norris <computersforpeace@gmail.com>
