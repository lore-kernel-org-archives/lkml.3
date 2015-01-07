Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbbAGShc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:37:32 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:59851 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbAGSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <1420394662-20011-1-git-send-email-me@mortis.eu>
References: <1420394662-20011-1-git-send-email-me@mortis.eu>
Date: Wed, 7 Jan 2015 20:37:29 +0200
Message-ID: <CAHp75VeZnmsRLV6_gg9Wci03ZEJCk=dRDEkp7DsEubypVvCi3A@mail.gmail.com>
Subject: Re: [PATCH] Fix error-code overwrite bug
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 8:04 PM, Giel van Schijndel <me@mortis.eu> wrote:
> Don't overwrite the returned error code with the boolean test used by
> the if-statement (otherwise it'd be 1 or 0 always, 1 in the if-block).
> ---
>  drivers/mtd/nftlmount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
> index 51b9d6a..1cbeb6b 100644
> --- a/drivers/mtd/nftlmount.c
> +++ b/drivers/mtd/nftlmount.c
> @@ -91,7 +91,7 @@ static int find_boot_record(struct NFTLrecord *nftl)
>                 /* To be safer with BIOS, also use erase mark as discriminant */
>                 if ((ret = nftl_read_oob(mtd, block * nftl->EraseSize +
>                                          SECTORSIZE + 8, 8, &retlen,
> -                                        (char *)&h1) < 0)) {
> +                                        (char *)&h1)) < 0) {

Better to move ret = x(); outside of condition. See here:
http://permalink.gmane.org/gmane.linux.drivers.mtd/56922

P.S.If you are going to fix more, may you talk to me via some channel
like irc, jabber, etc?


>                         printk(KERN_WARNING "ANAND header found at 0x%x in mtd%d, but OOB data read failed (err %d)\n",
>                                block * nftl->EraseSize, nftl->mbd.mtd->index, ret);
>                         continue;
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
