Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaA3OYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:24:32 -0500
Received: from relay2.sgi.com ([192.48.179.30]:46055 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753234AbaA3OYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:24:31 -0500
Date: Thu, 30 Jan 2014 08:24:30 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] gru: cleanup gru_dump_context() a little
Message-ID: <20140130142430.GA16259@sgi.com>
References: <20140130121048.GA17321@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130121048.GA17321@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Thu, Jan 30, 2014 at 03:10:48PM +0300, Dan Carpenter wrote:
> "ret" is zero here so we can remove the "!ret" part of the condition.
> "uhdr" is alread a __user pointer so we can remove the cast.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Btw, speaking of __user pointers there are some places where we
> dereference them in this file.  It's not a security problem because we
> have already used copy_to_user() to successfully write to the pointer at
> point.  But if you have something like PAX which puts user pointers and
> kernel pointers in a separate address space then this will cause
> problems.
> 
> Run sparse to see the issue.
> 
> diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
> index 2bef3f76032a..a3700a56b8ff 100644
> --- a/drivers/misc/sgi-gru/grukdump.c
> +++ b/drivers/misc/sgi-gru/grukdump.c
> @@ -178,10 +178,10 @@ static int gru_dump_context(struct gru_state *gru, int ctxnum,
>  	hdr.cbrcnt = cbrcnt;
>  	hdr.dsrcnt = dsrcnt;
>  	hdr.cch_locked = cch_locked;
> -	if (!ret && copy_to_user((void __user *)uhdr, &hdr, sizeof(hdr)))
> -		ret = -EFAULT;
> +	if (copy_to_user(uhdr, &hdr, sizeof(hdr)))
> +		return -EFAULT;
>  
> -	return ret ? ret : bytes;
> +	return bytes;
>  }
>  
>  int gru_dump_chiplet_request(unsigned long arg)
