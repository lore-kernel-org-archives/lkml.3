Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaLQRtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:49:41 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37814 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLQRtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:49:40 -0500
Date: Wed, 17 Dec 2014 14:49:30 -0300
From: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>
Subject: Re: [PATCH 2/2] UBI: rename_volumes: Use UBI_METAONLY
Message-ID: <20141217174930.GA3400@fox>
References: <1416864610-5751-1-git-send-email-richard@nod.at>
 <1416864610-5751-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416864610-5751-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 10:30:10PM +0100, Richard Weinberger wrote:
> By using UBI_METAONLY in rename_volumes() it is now possible to rename
> an UBI volume atomically while it is mounted.
> This is useful for firmware upgrades.
Minor nitpick: should this say 'while it is open for writing' or 'an
UBIFS volume'? Renaming volumes opened for read-only (with ubiblock on
top for example) was already supported.

Regardless:

Tested name swapping mounted UBIFS volumes and read-only ubiblocks, as
well as UBI volumes opened for writing (not updating).

(for both patches)
Tested-by: Guido Martínez <guido@vanguardiasur.com.ar>
Reviewed-by: Guido Martínez <guido@vanguardiasur.com.ar>

I'm not sure if we could now make the handler for UBI_IOCVOLUP take
read-write access instead of exclusive, but that's material for another
patch. Also I can't really think of a use case for that...


> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Andrew Murray <amurray@embedded-bits.co.uk>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/cdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
> index f5c715c..286383c 100644
> --- a/drivers/mtd/ubi/cdev.c
> +++ b/drivers/mtd/ubi/cdev.c
> @@ -736,7 +736,7 @@ static int rename_volumes(struct ubi_device *ubi,
>  			goto out_free;
>  		}
>  
> -		re->desc = ubi_open_volume(ubi->ubi_num, vol_id, UBI_READWRITE);
> +		re->desc = ubi_open_volume(ubi->ubi_num, vol_id, UBI_METAONLY);
>  		if (IS_ERR(re->desc)) {
>  			err = PTR_ERR(re->desc);
>  			ubi_err(ubi, "cannot open volume %d, error %d",
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Guido Martínez, VanguardiaSur
www.vanguardiasur.com.ar
