Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3CKNzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:55:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab3CKNzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:55:35 -0400
Date: Mon, 11 Mar 2013 14:55:32 +0100
From: Jan Kara <jack@suse.cz>
To: Ionut-Gabriel Radu <ihonius@gmail.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, artem.bityutskiy@linux.intel.com,
        shaggy@kernel.org, akpm@linux-foundation.org,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reiserfs: Use kstrdup instead of kmalloc/strcpy
Message-ID: <20130311135532.GF29799@quack.suse.cz>
References: <1362920783-17093-1-git-send-email-ihonius@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362920783-17093-1-git-send-email-ihonius@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 10-03-13 15:06:23, Ionut-Gabriel Radu wrote:
> Signed-off-by: Ionut-Gabriel Radu <ihonius@gmail.com>
  Thanks. Added to my tree.

								Honza

> ---
>  fs/reiserfs/super.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 194113b..f8a23c3 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -1147,8 +1147,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
>  							 "on filesystem root.");
>  					return 0;
>  				}
> -				qf_names[qtype] =
> -				    kmalloc(strlen(arg) + 1, GFP_KERNEL);
> +				qf_names[qtype] = kstrdup(arg, GFP_KERNEL);
>  				if (!qf_names[qtype]) {
>  					reiserfs_warning(s, "reiserfs-2502",
>  							 "not enough memory "
> @@ -1156,7 +1155,6 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
>  							 "quotafile name.");
>  					return 0;
>  				}
> -				strcpy(qf_names[qtype], arg);
>  				if (qtype == USRQUOTA)
>  					*mount_options |= 1 << REISERFS_USRQUOTA;
>  				else
> -- 
> 1.7.10.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
