Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3LQO6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:58:55 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33250 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LQO6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:58:53 -0500
Date: Tue, 17 Dec 2013 14:58:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/5] regulator: s5m8767: Add symbols for hard-coded
 DVS_RAMP register
Message-ID: <20131217145846.GA32283@lee--X1>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
 <20131217135153.GI19810@lee--X1>
 <1387289193.13191.9.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387289193.13191.9.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Krzysztof Kozlowski wrote:

> On Tue, 2013-12-17 at 13:51 +0000, Lee Jones wrote:
> > > Add symbols for hard-coded values of BUCK_RAMP field in DVS_RAMP
> > > register. This simplifies a little the code as register update is called
> > > only once.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > >  drivers/regulator/s5m8767.c         |   22 ++++++++++------------
> > >  include/linux/mfd/samsung/s5m8767.h |   15 +++++++++++++++
> > >  2 files changed, 25 insertions(+), 12 deletions(-)
> > 
> > <snip>
> > 
> > > diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
> > > index 9198377ee859..2ab0b0f03641 100644
> > > --- a/include/linux/mfd/samsung/s5m8767.h
> > > +++ b/include/linux/mfd/samsung/s5m8767.h
> > > @@ -186,4 +186,19 @@ enum s5m8767_regulators {
> > >  #define S5M8767_ENCTRL_SHIFT		6
> > >  #define S5M8767_ENCTRL_MASK		(0x3 << S5M8767_ENCTRL_SHIFT)
> > >  
> > > +/*
> > > + * Values for BUCK_RAMP field in DVS_RAMP register, matching raw values
> > > + * in mV/us.
> > > + */
> > > +enum s5m8767_dvs_buck_ramp_values {
> > > +	S5M8767_DVS_BUCK_RAMP_5		= 0x4,
> > > +	S5M8767_DVS_BUCK_RAMP_10	= 0x9,
> > > +	S5M8767_DVS_BUCK_RAMP_12_5	= 0xb,
> > > +	S5M8767_DVS_BUCK_RAMP_25	= 0xd,
> > > +	S5M8767_DVS_BUCK_RAMP_50	= 0xe,
> > > +	S5M8767_DVS_BUCK_RAMP_100	= 0xf,
> > > +};
> > 
> > Why do these have to be enums?
> 
> There is no special need. I chose enum because it is a kind of
> enumeration of all valid values for BUCK_RAMP field (valid according to
> datasheet). If you prefer #define then I'll change it.

I'm not fussed enough to make you resubmit.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
