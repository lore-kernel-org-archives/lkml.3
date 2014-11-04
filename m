Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbaKDAEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:04:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:57591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaKDAEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:04:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="630768494"
Date: Mon, 3 Nov 2014 16:04:42 -0800
From: steph <stephanie.s.wallick@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141104000442.GC8890@steph-desktop>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
 <20141103212139.GB7379@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103212139.GB7379@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 01:21:39PM -0800, Greg KH wrote:
> On Mon, Nov 03, 2014 at 12:42:48PM -0800, Stephanie Wallick wrote:
> > +EXPORT_SYMBOL(mausb_register_ms_driver);
> 
> EXPORT_SYMBOL_GPL()?  I have to ask...
>
The source is dual-licenced under BSD and GPL. It was our understanding
that dual-licensed should use EXPORT_SYMBOL() instead. Is that wrong?
 
> > +static int mausb_hcd_init(void)
> > +{
> > +	int ret;
> > +
> > +	/* register HCD driver */
> > +	ret = platform_driver_register(&mausb_driver);
> 
> Why is this a platform driver?  How does this relate to platform
> hardware?
> 
The driver doesn't require platform resources. It looks like a host
controller driver but communicates over the network instead of to
a physical host controller. There is no MA USB-specific hardware.

Should we use a struct device instead of a struct platform_device?

> > +	if (ret < 0) {
> > +		printk(KERN_DEBUG "%s: failed to register HC driver: "
> > +			" error number %d\n", __func__, ret);
> 
> pr_err()?
>
Will change all printk() to pr_err() in next patch.
 
> return here, that way you don't need:
> 
> > +	} else {
> 
> This indentation.
> 
Will fix in next patch.

> > +		/* register HCD device */
> > +		ret = platform_device_register(&mausb_pdev);
> 
> But again, why is this a platform device?  What platform resources does
> it have / require?
> 
See above.

> > +
> > +		if (ret < 0) {
> > +			printk(KERN_DEBUG "%s: failed to register HC device:"
> > +				"error number %d\n", __func__, ret);
> 
> pr_err()?
> 
See above.

> > +			platform_driver_unregister(&mausb_driver);
> > +		} else {
> > +			/* direct the release function (for exiting) */
> > +			mausb_pdev.dev.release = &mausb_dev_release;
> 
> That seems like a serious hack, why do you need to do this in this
> manner?
> 
This will go away when we get rid of the platform device.

> > +
> > +			if (ret < 0) {
> > +				printk(KERN_DEBUG "failed to register HC"
> > +					" chardev: error number %d\n", ret);
> 
> pr_err()?
>
See above.
 
> thanks,
> 
> greg k-h

Thanks,
Stephanie
