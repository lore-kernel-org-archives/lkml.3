Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3JGUQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:16:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3JGUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:15:58 -0400
Date: Mon, 7 Oct 2013 13:10:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add inline routine to free memory used in kobject name
Message-ID: <20131007201044.GA6305@kroah.com>
References: <5252f2cd.33yoX1hUWLRsRUrq%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252f2cd.33yoX1hUWLRsRUrq%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:43:41PM -0500, Larry Finger wrote:
> At present, if one wants to free the memory allocation used for
> a dev->kobj name, it is necessary to go quite deeply into the structure.

Why would you ever want to do this?

> To avoid this much dependence on the structure details in driver
> code, a new inline routine is created.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing-save/include/linux/device.h
> ===================================================================
> --- wireless-testing-save.orig/include/linux/device.h
> +++ wireless-testing-save/include/linux/device.h
> @@ -27,6 +27,7 @@
>  #include <linux/ratelimit.h>
>  #include <linux/uidgid.h>
>  #include <asm/device.h>
> +#include <linux/slab.h>
>  
>  struct device;
>  struct device_private;
> @@ -789,6 +790,11 @@ static inline const char *dev_name(const
>  	return kobject_name(&dev->kobj);
>  }
>  
> +static inline void dev_free_name(struct device *dev)
> +{
> +	kfree(dev->kobj.name);
> +}

Please show how you would use this function, I can't add functions that
no one calls.

And given that this type of thing hasn't been needed before, I'm
thinking that it still isn't needed :)

thanks,

greg k-h
