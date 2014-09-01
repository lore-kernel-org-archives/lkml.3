Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaIAIGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:06:19 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:51893 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaIAIFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315DB7BE@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DB7BE@NTXXIAMBX02.xacn.micron.com>
Date: Mon, 1 Sep 2014 10:05:15 +0200
X-Google-Sender-Auth: MU81oaqifxPkVpNguQM4JRmSuyo
Message-ID: <CABkLObq7N-_tD-RB+Z0R_DgGYETq-S+UucggFeyY6oK77xAbow@mail.gmail.com>
Subject: Re: [PATCH 1/1] mtd: cfi_cmdset_0002:add fixup for Micron M29EW after
 erase operation
From: Christian Riesch <christian.riesch@omicron.at>
To: bpqw <bpqw@micron.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 4:20 AM, bpqw <bpqw@micron.com> wrote:
> For Micron M29EW,20ms delay is needed after erase operation.
>
> Signed-off-by: BeanHuo <bpqw@micron.com>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index 5a4bfe3..9b0de91 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -509,6 +509,16 @@ static void cfi_fixup_m29ew_delay_after_resume(struct cfi_private *cfi)
>                 cfi_udelay(500);
>  }
>
> +static void cfi_fixup_m29ew_delay_after_erase(struct cfi_private *cfi)
> +{
> +       /*
> +        * Resolving the Delay After ERASE Issue @low temperature.
> +        * 20ms delay is needed after erase operation.
> +        */
> +       if (is_m29ew(cfi))
> +               cfi_udelay(20000);
> +}
> +
>  struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)  {
>         struct cfi_private *cfi = map->fldrv_priv; @@ -2397,6 +2407,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,

Missing line break? The patch does not apply.
Christian

>                 ret = -EIO;
>         }
>
> +       cfi_fixup_m29ew_delay_after_erase(cfi);
>         chip->state = FL_READY;
>         DISABLE_VPP(map);
>         put_chip(map, chip, adr);
> --
> 1.7.9.5
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
