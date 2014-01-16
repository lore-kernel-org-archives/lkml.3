Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaAPNFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:05:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:30514 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAPNFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:05:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="467642773"
Message-ID: <1389877509.3010.15.camel@rzhang1-mobl4>
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
From: Zhang Rui <rui.zhang@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        jarkko.nikula@linux.intel.com, mika.westerberg@linux.intel.com,
        grant.likely@secretlab.ca
Date: Thu, 16 Jan 2014 21:05:09 +0800
In-Reply-To: <20140116122704.GD2617@katana>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
	 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
	 <20140116122704.GD2617@katana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 13:27 +0100, Wolfram Sang wrote:
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index d74c0b3..c4c5588 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -104,6 +104,11 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
> >  static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  {
> >  	struct i2c_client	*client = to_i2c_client(dev);
> > +	int rc;
> > +
> > +	rc = acpi_device_uevent_modalias(dev, env);
> > +	if (rc != -ENODEV)
> > +		return rc;
> >  
> >  	if (add_uevent_var(env, "MODALIAS=%s%s",
> >  			   I2C_MODULE_PREFIX, client->name))
> 
> I wonder why we don't have/need that with CONFIG_OF? Because probably
> nobody is using modules with i2c devices there?
> 
This seems a gap to me but I'm not 100% sure.
I saw Grant Likely introduced the OF style MODALIAS to platform bus, and
OF style registration/binding to i2c bus, maybe he has an answer for
this.

thanks,
rui


