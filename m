Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaFYM4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:56:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35010 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaFYM4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:56:50 -0400
Date: Wed, 25 Jun 2014 13:56:48 +0100
From: Joel Becker <jlbec@evilplan.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [RFC 1/1] fs/configfs/dir.c: remove unused debugging functions
Message-ID: <20140625125648.GW30852@ZenIV.linux.org.uk>
Mail-Followup-To: Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Joe Perches <joe@perches.com>, akpm <akpm@linux-foundation.org>
References: <20140513203832.cb793ce47b8af993f561e5c2@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513203832.cb793ce47b8af993f561e5c2@skynet.be>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 08:38:32PM +0200, Fabian Frederick wrote:
> Joe Perches noticed it was not used anywhere.
> If there's no plan to use it in the future,
> we could simply remove both functions ...
> 
> Cc: Joe Perches <joe@perches.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

We used to flip DEBUG and insert them as needed.  It's been a while.

Acked-by: Joel Becker <jlbec@evilplan.org>


> ---
>  fs/configfs/dir.c | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index e081acb..1b12d0a 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -937,43 +937,6 @@ static void client_drop_item(struct config_item *parent_item,
>  		config_item_put(item);
>  }
>  
> -#ifdef DEBUG
> -static void configfs_dump_one(struct configfs_dirent *sd, int level)
> -{
> -	printk(KERN_INFO "%*s\"%s\":\n", level, " ", configfs_get_name(sd));
> -
> -#define type_print(_type) if (sd->s_type & _type) printk(KERN_INFO "%*s %s\n", level, " ", #_type);
> -	type_print(CONFIGFS_ROOT);
> -	type_print(CONFIGFS_DIR);
> -	type_print(CONFIGFS_ITEM_ATTR);
> -	type_print(CONFIGFS_ITEM_LINK);
> -	type_print(CONFIGFS_USET_DIR);
> -	type_print(CONFIGFS_USET_DEFAULT);
> -	type_print(CONFIGFS_USET_DROPPING);
> -#undef type_print
> -}
> -
> -static int configfs_dump(struct configfs_dirent *sd, int level)
> -{
> -	struct configfs_dirent *child_sd;
> -	int ret = 0;
> -
> -	configfs_dump_one(sd, level);
> -
> -	if (!(sd->s_type & (CONFIGFS_DIR|CONFIGFS_ROOT)))
> -		return 0;
> -
> -	list_for_each_entry(child_sd, &sd->s_children, s_sibling) {
> -		ret = configfs_dump(child_sd, level + 2);
> -		if (ret)
> -			break;
> -	}
> -
> -	return ret;
> -}
> -#endif
> -
> -
>  /*
>   * configfs_depend_item() and configfs_undepend_item()
>   *
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
