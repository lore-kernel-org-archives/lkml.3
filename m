Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaCQVjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:39:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCQVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:39:46 -0400
Date: Mon, 17 Mar 2014 14:41:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: jkc@redhat.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
Message-ID: <20140317214145.GA29105@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 07:37:50PM +0900, Daeseok Youn wrote:
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/unisys/uislib/uislib.c   |    5 +----
>  drivers/staging/unisys/uislib/uisutils.c |    2 +-
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
> index d77df9a..9748fcb 100644
> --- a/drivers/staging/unisys/uislib/uislib.c
> +++ b/drivers/staging/unisys/uislib/uislib.c
> @@ -339,8 +339,6 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
>  		return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
>  	}
>  
> -	memset(bus, 0, size);
> -
>  	/* Currently by default, the bus Number is the GuestHandle.
>  	 * Configure Bus message can override this.
>  	 */
> @@ -530,7 +528,6 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
>  		return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
>  	}
>  
> -	memset(dev, 0, sizeof(struct device_info));
>  	dev->channelTypeGuid = msg->cmd.createDevice.dataTypeGuid;
>  	dev->intr = msg->cmd.createDevice.intr;
>  	dev->channelAddr = msg->cmd.createDevice.channelAddr;
> @@ -1437,7 +1434,7 @@ uislib_malloc(size_t siz, gfp_t gfp, U8 contiguous, char *fn, int ln)
>  		* get memory for you (like, invoke oom killer), which
>  		* will probably cripple the system.
>  		*/
> -		p = kmalloc(siz, gfp | __GFP_NORETRY);
> +		p = kzalloc(siz, gfp | __GFP_NORETRY);
>  	}
>  	if (p == NULL) {
>  		LOGERR("uislib_malloc failed to alloc %d bytes @%s:%d",
> diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
> index 208b7ea..2f05be1 100644
> --- a/drivers/staging/unisys/uislib/uisutils.c
> +++ b/drivers/staging/unisys/uislib/uisutils.c
> @@ -294,7 +294,7 @@ ReqHandlerAdd(GUID switchTypeGuid,
>  	rc = UISMALLOC(sizeof(*rc), GFP_ATOMIC);
>  	if (!rc)
>  		return NULL;
> -	memset(rc, 0, sizeof(*rc));
> +
>  	rc->switchTypeGuid = switchTypeGuid;
>  	rc->controlfunc = controlfunc;
>  	rc->min_channel_bytes = min_channel_bytes;

Can you just remove the UISMALLOC() macro completly, so that it's easier
to verify that changes like this are actually correct?

thanks,

greg k-h
