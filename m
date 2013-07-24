Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798Ab3GXBFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:05:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3GXBFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:05:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,731,1367942400"; 
   d="scan'208";a="7998378"
Message-ID: <51EF278A.5060807@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 09:02:02 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andi Shyti <andi@etezian.org>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: bio-integrity: fix possible segmentation fault
References: <1374621131-9938-1-git-send-email-andi@etezian.org>
In-Reply-To: <1374621131-9938-1-git-send-email-andi@etezian.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 09:03:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 09:03:39,
	Serialize complete at 2013/07/24 09:03:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 07:12 AM, Andi Shyti wrote:

> free bvec_integrity_pool if it's allocated, not bio_integrity_pool
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>


Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  fs/bio-integrity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 8fb4291..45e944f 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -734,7 +734,7 @@ void bioset_integrity_free(struct bio_set *bs)
>  		mempool_destroy(bs->bio_integrity_pool);
>  
>  	if (bs->bvec_integrity_pool)
> -		mempool_destroy(bs->bio_integrity_pool);
> +		mempool_destroy(bs->bvec_integrity_pool);
>  }
>  EXPORT_SYMBOL(bioset_integrity_free);
>  


