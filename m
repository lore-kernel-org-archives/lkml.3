Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaENWBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:01:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaENWBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:01:46 -0400
Date: Thu, 15 May 2014 00:01:44 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] fs/reiserfs/stree.c: remove obsolete __constant
Message-ID: <20140514220143.GA20841@quack.suse.cz>
References: <20140503223324.4357f591dc8994b74f456440@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503223324.4357f591dc8994b74f456440@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 03-05-14 22:33:24, Fabian Frederick wrote:
> __constant_cpu_to_le32 converted to cpu_to_le32
> 
> Cc: reiserfs-devel@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  Just for my education, where have you learned that __constant_...
functions are obsolete?

								Honza
> ---
> V2: Cc email fixed
> 
>  fs/reiserfs/stree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
> index b14706a..615cd9a 100644
> --- a/fs/reiserfs/stree.c
> +++ b/fs/reiserfs/stree.c
> @@ -228,10 +228,10 @@ const struct reiserfs_key MIN_KEY = { 0, 0, {{0, 0},} };
>  
>  /* Maximal possible key. It is never in the tree. */
>  static const struct reiserfs_key MAX_KEY = {
> -	__constant_cpu_to_le32(0xffffffff),
> -	__constant_cpu_to_le32(0xffffffff),
> -	{{__constant_cpu_to_le32(0xffffffff),
> -	  __constant_cpu_to_le32(0xffffffff)},}
> +	cpu_to_le32(0xffffffff),
> +	cpu_to_le32(0xffffffff),
> +	{{cpu_to_le32(0xffffffff),
> +	  cpu_to_le32(0xffffffff)},}
>  };
>  
>  /* Get delimiting key of the buffer by looking for it in the buffers in the path, starting from the bottom
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
