Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735AbaH0Nzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:55:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34491 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934708AbaH0Nz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:55:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-87-53fde34f5fde
Content-transfer-encoding: 8BIT
Message-id: <1409147725.25748.1.camel@AMDC1943>
Subject: Re: [RESEND PATCH v3 3/6] charger: max14577: Configure
 battery-dependent settings from DTS and sysfs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jenny Tc <jenny.tc@intel.com>
Date: Wed, 27 Aug 2014 15:55:25 +0200
In-reply-to: <20140827135027.GF6364@lee--X1>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-4-git-send-email-k.kozlowski@samsung.com>
 <20140827135027.GF6364@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xK7r+j/8GG6xp5bPYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaLH2aw+7xdmmN+wW978eZbT4dqWDyWLz9w42i8u75rBZ
	fO49AlRy5C67xdLrF5ksJkxfy2LRuvcIu8XpblaL07tLHIQ91sxbw+hxua+XyWPnrLvsHiuX
	f2Hz2LxCy2PxnpdMHptWdbJ53Lm2h81j3slAj74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4MqY
	0trNWLCau+L2038sDYwfOboYOTkkBEwkXu3rZ4ewxSQu3FvP1sXIxSEksJRRYvHqK6wgCV4B
	QYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJ2bNXMYLU8AroS1x7EwZSIyyQLzGl
	/wMTiM0mYCyxefkSNpASEQEViXNvzEFamQV2sEoc3viKEaSGRUBVYk/PLlaQGk4BHYkdt3Mg
	xi9nlFj3v5EJJC4hoCzR2O82gVFgFpLjZiEcNwvJcQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al
	6yXn525ihMTilx2Mi49ZHWIU4GBU4uFlWP8nWIg1say4MvcQowQHs5IIb9mBv8FCvCmJlVWp
	RfnxRaU5qcWHGJk4OKUaGFsDRd+svaf0Ta7kuN/SJX4Vmt3G/Jw2QaZ/d/lPeMo7z6csZ8em
	Iy52P3/dtC9Z8WRjeMO+ZyptRpEmwgqLGMq5clSv9fecEGZS3WpU3zND5vaMvb+8DrBPXRJ1
	IzOq4srOkwpff1r0mRVE/rA/d+3vHI+dShVbZR7Jnbkb/N5bcouIY7HzciWW4oxEQy3mouJE
	AHKdda+jAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-08-27 at 14:50 +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> 
> > Remove hard-coded values for:
> >  - Fast Charge current,
> >  - End Of Charge current,
> >  - Fast Charge timer,
> >  - Overvoltage Protection Threshold,
> >  - Battery Constant Voltage,
> > and use DTS or sysfs to configure them. This allows using the max14577 charger
> > driver with different batteries.
> > 
> > Now the charger driver requires valid configuration data from DTS. In
> > case of wrong configuration data it fails during probe. Patch adds
> > of_compatible to the charger mfd cell in MFD driver core.
> > 
> > The fast charge timer is configured through sysfs entry.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Jenny Tc <jenny.tc@intel.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/max14577.c               |   5 +-
> 
> Hmm... not sure why I Acked this.  The code looks okay, but can you
> break out the MFD changed into a separate patch please?  You can add
> my Ack to the broken out patch though.

Sure, I'll split it however the compatible here in mfd_cell makes sense
only with this patch.

Best regards,
Krzysztof


