Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaDQCeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 22:34:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDQCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 22:34:01 -0400
Date: Wed, 16 Apr 2014 19:34:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER CORE] drivers/base/dd.c incorrect pr_debug() parameters
Message-ID: <20140417023404.GA6290@kroah.com>
References: <534F1C6E.7010606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534F1C6E.7010606@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 05:12:30PM -0700, Frank Rowand wrote:
> pr_debug() parameters are reverse order of format string
> 
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
> 
>  drivers/base/dd.c |    4 	2 +	2 -	0 !
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/base/dd.c
> ===================================================================

What is this, cvs?  :)

> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -187,8 +187,8 @@ static void driver_bound(struct device *
>  		return;
>  	}
>  
> -	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev_name(dev),
> -		 __func__, dev->driver->name);
> +	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev->driver->name,
> +		 __func__, dev_name(dev));

Thanks, I'll queue this up.

greg k-h
