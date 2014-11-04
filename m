Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaKDBA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:00:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:36876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaKDBA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:00:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="616484571"
Date: Mon, 3 Nov 2014 16:59:53 -0800
From: steph <stephanie.s.wallick@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141104005953.GA9755@steph-desktop>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
 <20141103212139.GB7379@kroah.com>
 <20141104000442.GC8890@steph-desktop>
 <20141104001355.GA10900@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104001355.GA10900@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:13:55PM -0800, Greg KH wrote:
> On Mon, Nov 03, 2014 at 04:04:42PM -0800, steph wrote:
> > On Mon, Nov 03, 2014 at 01:21:39PM -0800, Greg KH wrote:
> > > On Mon, Nov 03, 2014 at 12:42:48PM -0800, Stephanie Wallick wrote:
> > > > +EXPORT_SYMBOL(mausb_register_ms_driver);
> > > 
> > > EXPORT_SYMBOL_GPL()?  I have to ask...
> > >
> > The source is dual-licenced under BSD and GPL. It was our understanding
> > that dual-licensed should use EXPORT_SYMBOL() instead. Is that wrong?
> 
> Talk to your company lawyers please to get confirmation of what you want
> to do here, I can't answer this question, I just have to ask...
>
We have permission to go forward with the dual BSD/GPL license. I will leave
as is unless there is a future issue.
 
> > > > +static int mausb_hcd_init(void)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	/* register HCD driver */
> > > > +	ret = platform_driver_register(&mausb_driver);
> > > 
> > > Why is this a platform driver?  How does this relate to platform
> > > hardware?
> > > 
> > The driver doesn't require platform resources. It looks like a host
> > controller driver but communicates over the network instead of to
> > a physical host controller. There is no MA USB-specific hardware.
> > 
> > Should we use a struct device instead of a struct platform_device?
> 
> Yes, please make it a "virtual" device.
> 
Will do.

Thanks,
Stephanie

