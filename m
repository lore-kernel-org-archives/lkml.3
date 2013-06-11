Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab3FKELT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 00:11:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40346 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3FKELR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 00:11:17 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: RE: [PATCH v2 1/2] ARM: dts: add dtsi for palmas
Thread-Topic: [PATCH v2 1/2] ARM: dts: add dtsi for palmas
Thread-Index: AQHOZbmzfoqUH8UdZUCRG0oZF40Mz5kunb8AgAFGeDA=
Date: Tue, 11 Jun 2013 04:10:50 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EAD1B@DBDE04.ent.ti.com>
References: <1370855059-5342-1-git-send-email-j-keerthy@ti.com>
 <1370855059-5342-2-git-send-email-j-keerthy@ti.com>
 <51B5FEDE.5070900@wwwdotorg.org>
In-Reply-To: <51B5FEDE.5070900@wwwdotorg.org>
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
> Sent: Monday, June 10, 2013 9:59 PM
> To: J, KEERTHY
> Cc: Cousson, Benoit; devicetree-discuss@lists.ozlabs.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> sameo@linux.intel.com; gg@slimlogic.co.uk; lee.jones@linaro.org
> Subject: Re: [PATCH v2 1/2] ARM: dts: add dtsi for palmas
> 
> On 06/10/2013 03:04 AM, J Keerthy wrote:
> > Adds palmas mfd and palmas regulator nodes.
> 
> Nits:
> 
> Well, you're really adding files that provide the nodes, not the nodes
> themselves.
> 
> Palmas and MFD should be correctly capitalized.

Ok.

> 
> > diff --git a/arch/arm/boot/dts/palmas.dtsi
> > b/arch/arm/boot/dts/palmas.dtsi
> 
> > +&palmas {
> ...
> > +	palmas_pmic {
> ...
> > +		ti,ldo6-vibrator;
> 
> Isn't that board-specific? I don't know the HW well enough to say, but
> I assume that since there's a property, the whole point must be that
> some boards want it set and some don't.
> 

Yes. I will make this part of board file.

> > +		regulators {
> > +			smps123_reg: smps123 {
> > +				regulator-name = "smps123";
> > +			};
> 
> So the node labels here duplicate those in omap5-uevm.dts in patch 2/2.
> While dtc allows this, I don't think there's much point duplicating the
> labels. I'd tend to only put the labels in omap5-uevm.dts and not put
> them here. That will completely avoid the possibility of the labels in
> this file from conflicting with any other labels in any top-level
> board.dts file.
> 
> I also wonder if this file is actually terribly useful. The only thing
> that this file provides is the regulator-name property. It seems
> simpler just to put that into each board.dts file. The added advantage
> of doing that, is that if a board doesn't use a particular regulator,
> the node won't appear, and the regulator won't get registered.

Ok. I will transfer the entire code to omap5-uevm.dts.

Thanks for the review comments.

Regards,
Keerthy
