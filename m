Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3ASDI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:08:28 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51640 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3ASDI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:08:27 -0500
Date: Sat, 19 Jan 2013 04:08:27 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: gregkh@linuxfoundation.org, sjening@linux.vnet.ibm.com,
        konrad.wilk@oracle.com, xiaoguangrong@linux.vnet.ibm.com,
        dan.magenheimer@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: zcache-main: Fixed Camel Case Issue
Message-ID: <20130119030826.GG18593@gmail.com>
References: <20130119025640.GA32271@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119025640.GA32271@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 09:56:44PM -0500, Jake Champlin wrote:
> Fixed a camel case coding style issue.
> 
> Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
> ---
>  drivers/staging/zcache/zcache-main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 52b43b7..95be348 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -1851,7 +1851,7 @@ static int zcache_frontswap_store(unsigned type, pgoff_t offset,
>  	int ret = -1;
>  	unsigned long flags;
>  
> -	BUG_ON(!PageLocked(page));
> +	BUG_ON(!page_locked(page));
>  	if (likely(ind64 == ind)) {
>  		local_irq_save(flags);
>  		ret = zcache_put_page(LOCAL_CLIENT, zcache_frontswap_poolid,
> @@ -1871,7 +1871,7 @@ static int zcache_frontswap_load(unsigned type, pgoff_t offset,
>  	struct tmem_oid oid = oswiz(type, ind);
>  	int ret = -1;
>  
> -	BUG_ON(!PageLocked(page));
> +	BUG_ON(!page_locked(page));

again, that doesn't work. Did you try to build the code?

- cong

>  	if (likely(ind64 == ind))
>  		ret = zcache_get_page(LOCAL_CLIENT, zcache_frontswap_poolid,
>  					&oid, iswiz(ind), page);
> -- 
> 1.8.1.1
> 
> 
> -- 
> Jake Champlin
> jake.champlin.27@gmail.com
> 8123742937
> <MuttClient>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
