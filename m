Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaEHTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:03:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaEHTDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:03:18 -0400
Date: Thu, 8 May 2014 21:03:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Keith Busch <keith.busch@intel.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] driver-core: allow asynchronous device shutdown
Message-ID: <20140508190307.GA6766@kroah.com>
References: <1399572454-30239-1-git-send-email-keith.busch@intel.com>
 <1399572454-30239-2-git-send-email-keith.busch@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399572454-30239-2-git-send-email-keith.busch@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 12:07:33PM -0600, Keith Busch wrote:
> A patch to allow .shutdown to execute asynchronously. Some devices may
> take a long time to complete a shutdown, so this patch lets a driver
> safely shutdown multiple devices asynchronously.
> 
> This uses an exclusive asynchronous domain so other unrelated async
> tasks can't cause shutdown to hold up indefinitely.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/base/core.c    |    4 ++++
>  include/linux/device.h |    1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 20da3ad..71b83bb 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -10,6 +10,7 @@
>   *
>   */
>  
> +#include <linux/async.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> @@ -1926,6 +1927,8 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(device_move);
>  
> +ASYNC_DOMAIN_EXCLUSIVE(shutdown_domain);
> +EXPORT_SYMBOL(shutdown_domain);

EXPORT_SYMBOL_GPL() please, for driver core functions.

thanks,

greg k-h
