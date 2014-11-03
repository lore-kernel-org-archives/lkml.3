Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaKCVVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:21:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaKCVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:21:39 -0500
Date: Mon, 3 Nov 2014 13:21:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141103212139.GB7379@kroah.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 12:42:48PM -0800, Stephanie Wallick wrote:
> +EXPORT_SYMBOL(mausb_register_ms_driver);

EXPORT_SYMBOL_GPL()?  I have to ask...

> +static int mausb_hcd_init(void)
> +{
> +	int ret;
> +
> +	/* register HCD driver */
> +	ret = platform_driver_register(&mausb_driver);

Why is this a platform driver?  How does this relate to platform
hardware?

> +	if (ret < 0) {
> +		printk(KERN_DEBUG "%s: failed to register HC driver: "
> +			" error number %d\n", __func__, ret);

pr_err()?

return here, that way you don't need:

> +	} else {

This indentation.

> +		/* register HCD device */
> +		ret = platform_device_register(&mausb_pdev);

But again, why is this a platform device?  What platform resources does
it have / require?

> +
> +		if (ret < 0) {
> +			printk(KERN_DEBUG "%s: failed to register HC device:"
> +				"error number %d\n", __func__, ret);

pr_err()?

> +			platform_driver_unregister(&mausb_driver);
> +		} else {
> +			/* direct the release function (for exiting) */
> +			mausb_pdev.dev.release = &mausb_dev_release;

That seems like a serious hack, why do you need to do this in this
manner?

> +
> +			if (ret < 0) {
> +				printk(KERN_DEBUG "failed to register HC"
> +					" chardev: error number %d\n", ret);

pr_err()?

thanks,

greg k-h
