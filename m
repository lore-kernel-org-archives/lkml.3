Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaIPVTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:19:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaIPVTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:19:39 -0400
Date: Tue, 16 Sep 2014 23:19:35 +0200
From: Jan Kara <jack@suse.cz>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/22] isofs: Replace strnicmp with strncasecmp
Message-ID: <20140916211935.GH1205@quack.suse.cz>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
 <1410900696-6481-8-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410900696-6481-8-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-09-14 22:51:21, Rasmus Villemoes wrote:
> The kernel used to contain two functions for length-delimited,
> case-insensitive string comparison, strnicmp with correct semantics
> and a slightly buggy strncasecmp. The latter is the POSIX name, so
> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
> for the new strncasecmp to avoid breaking existing users.
> 
> To allow the compat wrapper strnicmp to be removed at some point in
> the future, and to avoid the extra indirection cost, do
> s/strnicmp/strncasecmp/g.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
  Looks good.

  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/isofs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 5ddaf86..881b3bd 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -247,7 +247,7 @@ static int isofs_dentry_cmp_common(
>  	}
>  	if (alen == blen) {
>  		if (ci) {
> -			if (strnicmp(name->name, str, alen) == 0)
> +			if (strncasecmp(name->name, str, alen) == 0)
>  				return 0;
>  		} else {
>  			if (strncmp(name->name, str, alen) == 0)
> -- 
> 2.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
