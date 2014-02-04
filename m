Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaBDRIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:08:42 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49960 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaBDRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:08:39 -0500
Date: Tue, 4 Feb 2014 17:08:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tim Kryger <tim.kryger@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mfd: add bcm59056 pmu driver
Message-ID: <20140204170832.GA5196@lee--X1>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
 <20140204143119.GA4627@beef>
 <20140204165906.GC22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140204165906.GC22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +static struct i2c_driver bcm59056_i2c_driver = {
> > > > +	.driver = {
> > > > +		   .name = "bcm59056",
> > > > +		   .owner = THIS_MODULE,
> > > > +		   .of_match_table = of_match_ptr(bcm59056_of_match),
> 
> > > No need to use of_match_ptr() here.
> 
> > Will remove.
> 
> What using of_match_ptr() should do is allow the compiler to figure out
> that the table isn't used when DT is disabled and discard it without
> ifdefs.  Not sure if that actually works yet but that's the idea.

Right, but I'm guessing that as there is no support for platform data
then this device(s) is going to be DT only? If that's the case perhaps
a 'depends OF' might be in order. If that's not the case then I'm more
than happy to leave the of_match_ptr() in.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
