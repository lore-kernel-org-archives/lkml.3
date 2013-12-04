Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab3LDSf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:35:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3LDSfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:35:55 -0500
Date: Wed, 4 Dec 2013 10:35:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: arve@android.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, ccross@android.com, Dave.Butcher@arm.com,
        irogers@google.com, romlem@android.com
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
Message-ID: <20131204183554.GA16693@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:09:41PM +0000, Serban Constantinescu wrote:
> +#define size_helper(x) ({						    \
> +	size_t __size;							    \
> +	if (!is_compat_task())						    \
> +		__size = sizeof(x);					    \
> +	else if (sizeof(x) == sizeof(struct flat_binder_object))	    \
> +		__size = sizeof(struct compat_flat_binder_object);	    \
> +	else if (sizeof(x) == sizeof(struct binder_transaction_data))	    \
> +		__size = sizeof(struct compat_binder_transaction_data);	    \
> +	else if (sizeof(x) == sizeof(size_t))				    \
> +		__size = sizeof(compat_size_t);				    \
> +	else								    \
> +		 BUG();							    \
> +	__size;								    \
> +	})

Ick.

First off, no driver should ever be able to crash the kernel, which you
just did.

Second, almost none of those "if" lines will ever be hit, why did you
include it all?

And finally, is this all really needed?  Why not just fix the structures
to be "correct", and then fix userspace to use the correct structures as
well, thereby not needing a compat layer at all?

You have the chance to fix the api properly, why not take it and do it,
making all of this unnecessary.

thanks,

greg k-h
