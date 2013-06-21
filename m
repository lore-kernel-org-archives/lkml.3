Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857Ab3FUOK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:10:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38574 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161446Ab3FUOKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:10:25 -0400
Date: Fri, 21 Jun 2013 09:09:08 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joshua Morris <josh.h.morris@us.ibm.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] rsxx: returning bytes remaining instead of -EFAULT
Message-ID: <20130621140908.GP6492@oc6784271780.ibm.com>
References: <20130621062111.GC10873@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621062111.GC10873@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062114-7182-0000-0000-00000775AF75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 09:21:11AM +0300, Dan Carpenter wrote:
> copy_to/from_user() returns the number of bytes remaining to be copied.
> We should return -EFAULT here instead.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
> index 6e85e21..102dc60 100644
> --- a/drivers/block/rsxx/core.c
> +++ b/drivers/block/rsxx/core.c
> @@ -199,9 +199,8 @@ static ssize_t rsxx_cram_read(struct file *fp, char __user *ubuf,
>  	if (st)
>  		return st;
> 
> -	st = copy_to_user(ubuf, buf, cnt);
> -	if (st)
> -		return st;
> +	if (copy_to_user(ubuf, buf, cnt))
> +		return -EFAULT;
> 
>  	info->offset += cnt;
> 
> @@ -222,9 +221,8 @@ static ssize_t rsxx_cram_write(struct file *fp, const char __user *ubuf,
>  	if (!buf)
>  		return -ENOMEM;
> 
> -	st = copy_from_user(buf, ubuf, cnt);
> -	if (st)
> -		return st;
> +	if (copy_from_user(buf, ubuf, cnt))
> +		return -EFAULT;
> 
>  	info->f_pos = (u32)*ppos + info->offset;

Thank You for noticing that mistake on my part.

> 
> 

