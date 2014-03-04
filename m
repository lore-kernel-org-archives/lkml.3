Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaCDTmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:42:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42772 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751908AbaCDTmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:42:09 -0500
Date: Tue, 4 Mar 2014 14:42:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valentina Manea <valentina.manea.m@gmail.com>
cc: gregkh@linuxfoundation.org, <ly80toro@cip.cs.fau.de>,
        <ke42caxa@cip.cs.fau.de>, <eladwexler77@yahoo.com>,
        <oat.elena@gmail.com>, <josh@joshtriplett.org>, <himangi774@gmail.com>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <andy.grover@gmail.com>,
        <firefly@lists.rosedu.org>
Subject: Re: [PATCH] staging: usbip: claim ports used by shared devices
In-Reply-To: <1393961104-21856-1-git-send-email-valentina.manea.m@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403041440320.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Valentina Manea wrote:

> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 90e18f6..a91dc1f 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -62,23 +62,6 @@
>  /* Mutual exclusion for removal, open, and release */
>  DEFINE_MUTEX(usbfs_mutex);
>  
> -struct dev_state {
> -	struct list_head list;      /* state list */
> -	struct usb_device *dev;
> -	struct file *file;
> -	spinlock_t lock;            /* protects the async urb lists */
> -	struct list_head async_pending;
> -	struct list_head async_completed;
> -	wait_queue_head_t wait;     /* wake up if a request completed */
> -	unsigned int discsignr;
> -	struct pid *disc_pid;
> -	const struct cred *cred;
> -	void __user *disccontext;
> -	unsigned long ifclaimed;
> -	u32 secid;
> -	u32 disabled_bulk_eps;
> -};
> -

Don't remove this definition.

> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 22de4af..e0843a4 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -366,6 +366,24 @@ struct usb_bus {
>  #endif
>  };
>  
> +struct dev_state {
> +	struct list_head list;      /* state list */
> +	struct usb_device *dev;
> +	struct file *file;
> +	spinlock_t lock;            /* protects the async urb lists */
> +	struct list_head async_pending;
> +	struct list_head async_completed;
> +	wait_queue_head_t wait;     /* wake up if a request completed */
> +	unsigned int discsignr;
> +	struct pid *disc_pid;
> +	const struct cred *cred;
> +	void __user *disccontext;
> +	unsigned long ifclaimed;
> +	u32 secid;
> +	u32 disabled_bulk_eps;
> +};

And don't put this here.  Instead, just put

struct dev_state;

Alan Stern

