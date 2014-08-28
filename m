Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbaH1MmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:42:15 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34783 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaH1MmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:42:12 -0400
Date: Thu, 28 Aug 2014 13:42:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Message-ID: <20140828124205.GS24579@lee--X1>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-7-git-send-email-k.kozlowski@samsung.com>
 <20140828115219.GQ24579@lee--X1>
 <1409228894.25322.15.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409228894.25322.15.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Krzysztof Kozlowski wrote:

> On czw, 2014-08-28 at 12:52 +0100, Lee Jones wrote:
> > On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> > 
> > > MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
> > > can be safely re-used. The patch adds MAX77836 ID to array of
> > > i2c_device_id.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/power/max17040_battery.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
> > > index 0fbac861080d..165ffe381803 100644
> > > --- a/drivers/power/max17040_battery.c
> > > +++ b/drivers/power/max17040_battery.c
> > > @@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
> > >  
> > >  static const struct i2c_device_id max17040_id[] = {
> > >  	{ "max17040", 0 },
> > > +	{ "max77836-battery", 0 },
> > 
> > Are you sure you want the IDs to be the same?
> > 
> > If they are not used, just drop them entirely.
> 
> They are not used but you're right that the ID should be different. I'll
> add an local enum for the ID.

If they're not used, drop them.

 { "max17040" },
 { "max77836-battery" },

> > >  	{ }
> > >  };
> > >  MODULE_DEVICE_TABLE(i2c, max17040_id);
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
