Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaKKMiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:38:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:34573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaKKMiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:38:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="605901644"
Date: Tue, 11 Nov 2014 14:38:08 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141111123808.GM5826@lpalcu-linux>
References: <1415364314-30320-1-git-send-email-laurentiu.palcu@intel.com>
 <1415364314-30320-2-git-send-email-laurentiu.palcu@intel.com>
 <20141108104606.GH2722@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141108104606.GH2722@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Nov 08, 2014 at 10:46:06AM +0000, Mark Brown wrote:
> On Fri, Nov 07, 2014 at 02:45:13PM +0200, Laurentiu Palcu wrote:
> 
> > +static int dln2_spi_transfer_one_message(struct spi_master *master,
> > +					 struct spi_message *msg)
> 
> It's a bit sad not to do transfer_one() but it's reasonable not to
> because of the fun way /CS is being set.
My first attempts were with transfer_one()/set_cs() until I realized,
using an oscilloscope, that DLN2 automatically toggles the /CS during
read/write operations and that DLN2_SPI_SET_SS only instructs device
which CS pins to toggle... :/

> 
> > +	ret = dln2_spi_get_speed_range(dln2,
> > +					   &master->min_speed_hz,
> > +					   &master->max_speed_hz);
> 
> Strange indentation here.
I did some last minute function renaming and forgot to re-indent. Will
fix in v2.
> 
> > +static int dln2_spi_remove(struct platform_device *pdev)
> > +{
> > +	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
> > +	struct dln2_spi *dln2 = spi_master_get_devdata(master);
> > +
> > +	if (dln2_spi_enable(dln2, false) < 0)
> > +		dev_err(&pdev->dev, "Failed to disable SPI module\n");
> > +
> > +	spi_master_put(master);
> 
> You shouldn't need this _put(), it's defeating the purpose of having the
> devm_ registration.
Agreed! I used spi-rockchip.c as a template and I took it for granted.
I'll remove this line in v2. And, if you think it's worth it, I can send
a separate patch for spi-rockchip.c too.

thanks,
laurentiu



