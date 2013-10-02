Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3JBT7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:59:40 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33016 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3JBT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_=Y=YwCWSFjcacJ14yKUidmmJTHnKKibU6haoBUeNacA@mail.gmail.com>
References: <CAPgLHd_=Y=YwCWSFjcacJ14yKUidmmJTHnKKibU6haoBUeNacA@mail.gmail.com>
Date: Wed, 2 Oct 2013 12:59:38 -0700
Message-ID: <CAN8TOE96Ax_gyeG5fXHejHE6gCmxNchioy1BrE8a6B83kK7A8g@mail.gmail.com>
Subject: Re: [PATCH] UBIFS: fix error return code in ubifs_remount_rw() and ubifs_fill_super()
From: Brian Norris <computersforpeace@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, yongjun_wei@trendmicro.com.cn,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Wei Yongjun <weiyj.lk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump, Artem? I'm cleaning out my old email, and this patch looks
obviously correct.

On Thu, Jun 6, 2013 at 7:17 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENOMEM in the kmalloc() and d_make_root() error handling
> case instead of 0, as done elsewhere in those functions.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/ubifs/super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index f21acf0..673b4bc 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1629,8 +1629,10 @@ static int ubifs_remount_rw(struct ubifs_info *c)
>         }
>
>         c->write_reserve_buf = kmalloc(COMPRESSED_DATA_NODE_BUF_SZ, GFP_KERNEL);
> -       if (!c->write_reserve_buf)
> +       if (!c->write_reserve_buf) {
> +               err = -ENOMEM;
>                 goto out;
> +       }
>
>         err = ubifs_lpt_init(c, 0, 1);
>         if (err)
> @@ -2063,8 +2065,10 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
>         }
>
>         sb->s_root = d_make_root(root);
> -       if (!sb->s_root)
> +       if (!sb->s_root) {
> +               err = -ENOMEM;
>                 goto out_umount;
> +       }
>
>         mutex_unlock(&c->umount_mutex);
>         return 0;
>
>
