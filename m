Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3JJIVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:21:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:34272 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab3JJIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="306016501"
Date: Thu, 10 Oct 2013 11:26:34 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-acpi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: attach/detach I2C client device to the ACPI
 power domain
Message-ID: <20131010082634.GF3521@intel.com>
References: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
 <1381327461-10562-3-git-send-email-mika.westerberg@linux.intel.com>
 <20131010080919.GC2638@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010080919.GC2638@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:09:19AM +0200, Wolfram Sang wrote:
> On Wed, Oct 09, 2013 at 05:04:20PM +0300, Mika Westerberg wrote:
> > From: Lv Zheng <lv.zheng@intel.com>
> > 
> > If the I2C client device is enumerated from ACPI namespace it might have
> > ACPI methods that needs to be called in order to transition the device to
> > different power states (such as _PSx).
> > 
> > Implement this for I2C client devices by checking if the device has an ACPI
> > handle and if that's the case, attach it to the ACPI power domain. In
> > addition we make sure that the device is fully powered when its ->probe()
> > function gets called.
> > 
> > For non-ACPI devices this patch is a no-op.
> > 
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/i2c/i2c-core.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index 29d3f04..f25dee3 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -254,10 +254,16 @@ static int i2c_device_probe(struct device *dev)
> >  					client->flags & I2C_CLIENT_WAKE);
> >  	dev_dbg(dev, "probe\n");
> >  
> > +	if (ACPI_HANDLE(&client->dev))
> > +		acpi_dev_pm_attach(&client->dev, true);
> 
> I'd prefer to drop the 'if's in case they are checked inside the acpi_*
> calls anyway. Not a show-stopper, though, so:

OK, I'll drop them then from the final version.

> Acked-by: Wolfram Sang <wsa@the-dreams.de>
> 

Thanks!
