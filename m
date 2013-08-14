Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342Ab3HNSfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:35:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276Ab3HNSe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:34:58 -0400
Date: Wed, 14 Aug 2013 11:34:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiaolong Ye <yexl@marvell.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: add uio_event_sync interface
Message-ID: <20130814183457.GA25715@kroah.com>
References: <1376483423-603-1-git-send-email-yexl@marvell.com>
 <1376483423-603-2-git-send-email-yexl@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376483423-603-2-git-send-email-yexl@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:30:23PM +0800, Xiaolong Ye wrote:
> This interface is called to sync listener->event_count and device
> event count in multi-instances case.
> 
> Change-Id: Ibb1e4888ce55b4993394b61e4bcd6dce8b8291f0

What is this for?  (hint, it should never be in a kernel patch...)

> Signed-off-by: Xiaolong Ye <yexl@marvell.com>
> ---
>  drivers/uio/uio.c          |   12 ++++++++++++
>  include/linux/uio_driver.h |    1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index ba47563..95d559f 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -408,6 +408,18 @@ void uio_event_notify(struct uio_info *info)
>  EXPORT_SYMBOL_GPL(uio_event_notify);
>  
>  /**
> + * uio_event_sync - sync listener's event count with UIO device
> + * @listener: uio_listener structure
> + */
> +void uio_event_sync(struct uio_listener *listener)
> +{
> +	struct uio_device *idev = listener->dev;
> +
> +	listener->event_count = atomic_read(&idev->event);

What prevents that count from changing right after you call this
function?

> +}
> +EXPORT_SYMBOL_GPL(uio_event_sync);

You are exporting a symbol, yet never using it, which means I can't
accept this patch, sorry.

greg k-h
