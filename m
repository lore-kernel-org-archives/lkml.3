Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab3FRQ5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:57:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49847 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3FRQ5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:57:09 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH v2 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Thread-Topic: [PATCH v2 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Thread-Index: AQHObAyHZpmkE/knmUuTOIbrHZosqpk7Ga2AgACXajA=
Date: Tue, 18 Jun 2013 16:56:13 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EC576@DBDE04.ent.ti.com>
References: <1371549794-7406-1-git-send-email-j-keerthy@ti.com>
 <51C0826B.4060101@wwwdotorg.org>
In-Reply-To: <51C0826B.4060101@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,


> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Tuesday, June 18, 2013 9:23 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
> ldewangan@nvidia.com; sameo@linux.intel.com; grant.likely@secretlab.ca;
> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH v2 2/4] MFD: Palmas: Add SMPS10_BOOST feature
> 
> On 06/18/2013 04:03 AM, J Keerthy wrote:
> > The SMPS10 regulator is not presesnt in all the variants of the
> PALMAS
> > PMIC family. Hence adding a feature to distingush between them.
> 
> > diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> 
> > +	match = of_match_device(of_match_ptr(of_palmas_match_tbl),
> > +&i2c->dev);
> > +
> > +	if (match) {
> > +		features = (unsigned int *)match->data;
> > +		palmas->features = *features;
> > +	} else {
> > +		return -ENODATA;
> > +	}
> 
> 
> I think it's more common to do the error-checking first. That way, the
> success-case code doesn't need an indent:
> 
> match = of_match...(...);
> if (!match)
>     return -ENODATA;
> 
> features = ...;
> palmas->features = *features;

Sure. I will fix this.

Regards,
Keerthy

