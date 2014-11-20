Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaKTIiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:38:13 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42973 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaKTIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:38:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141120081538.GJ7996@ZenIV.linux.org.uk>
References: <20141120081538.GJ7996@ZenIV.linux.org.uk>
Date: Thu, 20 Nov 2014 10:38:10 +0200
X-Google-Sender-Auth: y8zc37zVfj5m-VtbEN_bJYU9_2s
Message-ID: <CAPcc5Pjb7Nd3OFBdf4nCPTKPYZBU8gJp8WJB9VdPxJtPV+NE_Q@mail.gmail.com>
Subject: Re: mlx4: don't duplicate kvfree()
From: Amir Vadai <amirv@mellanox.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Vadai <amirv@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:15 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
> index 193a6ad..d6f5496 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mr.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
> @@ -130,10 +130,7 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
>
>  err_out_free:
>         for (i = 0; i <= buddy->max_order; ++i)
> -               if (buddy->bits[i] && is_vmalloc_addr(buddy->bits[i]))
> -                       vfree(buddy->bits[i]);
> -               else
> -                       kfree(buddy->bits[i]);
> +               kvfree(buddy->bits[i]);
>
>  err_out:
>         kfree(buddy->bits);
> @@ -147,10 +144,7 @@ static void mlx4_buddy_cleanup(struct mlx4_buddy *buddy)
>         int i;
>
>         for (i = 0; i <= buddy->max_order; ++i)
> -               if (is_vmalloc_addr(buddy->bits[i]))
> -                       vfree(buddy->bits[i]);
> -               else
> -                       kfree(buddy->bits[i]);
> +               kvfree(buddy->bits[i]);
>
>         kfree(buddy->bits);
>         kfree(buddy->num_free);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thanks Al

Acked-by: Amir Vadai <amirv@mellanox.com>
