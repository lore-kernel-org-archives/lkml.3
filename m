Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaBDPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:21:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41575 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:21:51 -0500
Date: Tue, 4 Feb 2014 15:20:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mfd: add bcm59056 pmu driver
Message-ID: <20140204152056.GB3154@lee--X1>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-4-git-send-email-mporter@linaro.org>
 <20140204132951.GE13529@lee--X1>
 <20140204143119.GA4627@beef>
 <20140204144731.GA3154@lee--X1>
 <20140204150156.GC4627@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140204150156.GC4627@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ... then you'll still need this.
> 
> Yes, I was far too vague..I'm going to stop explicitly populating the
> data field.
> 
> static const struct of_device_id bcm59056_of_match[] = {
> 	{ .compatible = "brcm,bcm59056"},
> 	{ }
> };

+1

> > And I don't think you can drop this, as the I2C subsystem still
> > insists on it.
> 
> Agreed. I'm just dropping explicit population of the driver_data field
> here.
> 
> static const struct i2c_device_id bcm59056_i2c_id[] = {
> 	{ "bcm59056" },
> 	{ }
> };

+1

> > I think you need to keep this to supply the silly I2C ID table.
> > 
> > I would just omit the '.data = (void *) VERSION' from the
> > of_match_table until you require it. 
> 
> Well, it's not even necessary for I2C ID table. the I2C subsystem is
> happy with just a matching entry on the i2c_device_id name field and
> NULL driver_data. palmas is implemented in this manner.

Guess what? +1 :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
