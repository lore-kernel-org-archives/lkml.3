Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152Ab3DPQg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:36:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935965Ab3DPQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:25 -0400
Date: Mon, 15 Apr 2013 13:52:00 +0200
From: Jan Kara <jack@suse.cz>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: reiserfs: Use kstrdup function
Message-ID: <20130415115200.GA2299@quack.suse.cz>
References: <1365729618-24397-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365729618-24397-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-04-13 04:20:18, Alexandru Gheorghiu wrote:
> Use kstrdup function instead of kmalloc and strcpy.
> Patch found using coccinelle.
  Thanks for the patch but I already have a similar patch in my tree.

									Honza
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
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
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
