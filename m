Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaGUUVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:21:05 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45970 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821AbaGUUVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:21:03 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2014 16:21:03 EDT
Date: Mon, 21 Jul 2014 15:12:09 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/misc/sgi-gru/grukdump.c: drop negativity
 check for unsgined req.gid
Message-ID: <20140721201209.GA19927@sgi.com>
References: <1405605307-13657-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405605307-13657-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Thu, Jul 17, 2014 at 04:55:07PM +0300, Andrey Utkin wrote:
> [linux-3.16-rc5/drivers/misc/sgi-gru/grukdump.c:199]: (style) Checking if
> unsigned variable 'gid' is less than zero.
> 
>     if (req.gid >= gru_max_gids || req.gid < 0)
>         return -EINVAL;
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80461
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  drivers/misc/sgi-gru/grukdump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
> index a3700a5..e0e0e7e 100644
> --- a/drivers/misc/sgi-gru/grukdump.c
> +++ b/drivers/misc/sgi-gru/grukdump.c
> @@ -196,7 +196,7 @@ int gru_dump_chiplet_request(unsigned long arg)
>  		return -EFAULT;
>  
>  	/* Currently, only dump by gid is implemented */
> -	if (req.gid >= gru_max_gids || req.gid < 0)
> +	if (req.gid >= gru_max_gids)
>  		return -EINVAL;
>  
>  	gru = GID_TO_GRU(req.gid);
> -- 
> 1.8.5.5
