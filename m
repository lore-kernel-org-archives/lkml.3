Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaKCV2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:28:16 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49676 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbaKCV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:28:12 -0500
Message-ID: <1415050088.20372.72.camel@x220>
Subject: Re: [RESUBMIT PATCH v6 1/8] mfd: Add support for Skyworks SKY81452
 driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: gyungoh@gmail.com, sameo@linux.intel.com, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Date: Mon, 03 Nov 2014 22:28:08 +0100
In-Reply-To: <20141103171451.GG12011@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1414739322-12487-2-git-send-email-jack.yoo@skyworksinc.com>
	 <20141103171451.GG12011@x1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2014 21:28:09.0838 (UTC) FILETIME=[10AF98E0:01CFF7AD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 17:14 +0000, Lee Jones wrote:
>On Fri, 31 Oct 2014, gyungoh@gmail.com wrote:
> Code looks fine, but what are its dependencies.  I'm assuming nothing;
> however, did Mark say that something depends on it?

That would be REGULATOR_SKY81452. That is currently dangling (since
v3.18-rc1) as it depends on the non-existent symbol SKY81452.

> If so, what and what are you going to do about it?

See 7/8. That patch makes REGULATOR_SKY81452 depend on MFD_SKY81452,
making it buildable.

> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 1456ea7..a54244c 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -693,6 +693,18 @@ config MFD_SM501_GPIO
> >  	 lines on the SM501. The platform data is used to supply the
> >  	 base number for the first GPIO line to register.
> >  
> > +config MFD_SKY81452
> > +	tristate "Skyworks Solutions SKY81452"
> > +	select MFD_CORE
> > +	select REGMAP_I2C
> > +	depends on I2C
> > +	help
> > +	  This is the core driver for the Skyworks SKY81452 backlight and
> > +	  voltage regulator device.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called sky81452.
> > +
> >  config MFD_SMSC
> >         bool "SMSC ECE1099 series chips"
> >         depends on I2C=y


Paul Bolle

