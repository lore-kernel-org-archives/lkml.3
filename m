Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbbAUTRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:17:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:30062 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbbAUTRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:17:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,443,1418112000"; 
   d="scan'208";a="673628423"
Date: Wed, 21 Jan 2015 11:16:29 -0800
From: Todd E Brandt <todd.e.brandt@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        sameo@linux.intel.com, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com,
        todd.e.brandt@intel.com
Subject: Re: [PATCH 1/3] mfd/axp20x: change battery cell name to fuel gauge
Message-ID: <20150121191629.GA15525@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
References: <20150107212450.GB3440@linux.intel.com>
 <20150120114725.GI13701@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150120114725.GI13701@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:47:25AM +0000, Lee Jones wrote:
> On Wed, 07 Jan 2015, Todd E Brandt wrote:
> 
> > mfd/axp20x: change battery cell name to fuel gauge
> > 
> > Name changes to the battery cell structure to a
> > more generic cell type: fuel gauge.
> > 
> > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > ----
> >  drivers/mfd/axp20x.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> > index b1b580a..e75717e 100644
> > --- a/drivers/mfd/axp20x.c
> > +++ b/drivers/mfd/axp20x.c
> > @@ -87,7 +87,7 @@ static struct resource axp20x_pek_resources[] = {
> >  	},
> >  };
> >  
> > -static struct resource axp288_battery_resources[] = {
> > +static struct resource axp288_fuel_gauge_resources[] = {
> >  	{
> >  		.start = AXP288_IRQ_QWBTU,
> >  		.end   = AXP288_IRQ_QWBTU,
> > @@ -236,7 +236,7 @@ static const struct i2c_device_id axp20x_i2c_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
> >  
> > -static const struct acpi_device_id axp20x_acpi_match[] = {
> > +static struct acpi_device_id axp20x_acpi_match[] = {
> 
> Why have you dropped the cost qualifier here?

That's a bug, I shouldn't have removed the const qualifier, I'll submit a
v2 patch with this change removed. Thanks for the catch.

> 
> [...]
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
