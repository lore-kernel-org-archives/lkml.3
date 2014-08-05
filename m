Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaHEGib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:38:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:38417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbaHEGi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:38:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,804,1400050800"; 
   d="scan'208";a="583509078"
Date: Tue, 5 Aug 2014 09:38:25 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCHv2 5/6] base: platform: name the device already during
 allocation
Message-ID: <20140805063824.GA21849@xps8300>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1401972778-5880-6-git-send-email-heikki.krogerus@linux.intel.com>
 <53C3767A.9000203@ti.com>
 <20140714145543.GB11477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714145543.GB11477@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 07:55:43AM -0700, Greg Kroah-Hartman wrote:
> > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > index 9e9227e..e856bc4 100644
> > > --- a/drivers/base/platform.c
> > > +++ b/drivers/base/platform.c
> > > @@ -177,11 +177,45 @@ struct platform_object {
> > >   */
> > >  void platform_device_put(struct platform_device *pdev)
> > >  {
> > > -	if (pdev)
> > > -		put_device(&pdev->dev);
> > > +	if (!pdev)
> > > +		return;
> > > +
> > > +	if (pdev->id_auto) {
> > > +		ida_simple_remove(&platform_devid_ida, pdev->id);
> > > +		pdev->id = PLATFORM_DEVID_AUTO;
> > > +	}
> > > +
> > > +	put_device(&pdev->dev);
> > >  }
> > >  EXPORT_SYMBOL_GPL(platform_device_put);
> 
> Why would a single call to this function remove an id?  That seems
> really wrong, you should be able to call get and put on a device
> numerous times, only the "last" reference should cause the device to be
> cleaned up.
> 
> Shouldn't this be in the release function instead?

I'll fix this.

Thanks Greg.

-- 
heikki
