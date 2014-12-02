Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaLBJJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:09:11 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:15665 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbaLBJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:09:08 -0500
X-IronPort-AV: E=Sophos;i="5.07,499,1413237600"; 
   d="scan'208";a="110641566"
Date: Tue, 2 Dec 2014 10:09:02 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
In-Reply-To: <20141202085950.GA13434@mwanda>
Message-ID: <alpine.DEB.2.10.1412021007560.2483@hadrien>
References: <20141202085950.GA13434@mwanda>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -403,9 +408,10 @@ The rationale is:
>  int fun(int a)
>  {
>  	int result = 0;
> -	char *buffer = kmalloc(SIZE);
> +	char *buffer;
>
> -	if (buffer == NULL)
> +	buffer = kmalloc(SIZE);

kmalloc actually takes two arguments.  Perhaps it would be better to show
something that looks like a valid call.

Otherwise,

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

julia

> +	if (!buffer)
>  		return -ENOMEM;
>
>  	if (condition1) {
> @@ -413,14 +419,25 @@ int fun(int a)
>  			...
>  		}
>  		result = 1;
> -		goto out;
> +		goto out_buffer;
>  	}
>  	...
> -out:
> +out_buffer:
>  	kfree(buffer);
>  	return result;
>  }
>
> +A common type of bug to be aware of it "one err bugs" which look like this:
> +
> +err:
> +	kfree(foo->bar);
> +	kfree(foo);
> +	return ret;
> +
> +The bug in this code is that on some exit paths "foo" is NULL.  Normally the
> +fix for this is to split it up into two error labels "err_bar:" and "err_foo:".
> +
> +
>  		Chapter 8: Commenting
>
>  Comments are good, but there is also a danger of over-commenting.  NEVER
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
