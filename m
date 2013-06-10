Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3FJKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:18:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46381 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab3FJKSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:18:16 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
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
Subject: RE: [PATCH] ARM: dts: add dtsi for palmas
Thread-Topic: [PATCH] ARM: dts: add dtsi for palmas
Thread-Index: AQHOY3QMPa6kmxyASkaofO5W52VCRJkqJRKAgAQxKl///9bYgIAAk0ug
Date: Mon, 10 Jun 2013 10:17:58 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EABB4@DBDE04.ent.ti.com>
References: <1370604504-32310-1-git-send-email-j-keerthy@ti.com>,<51B23AD5.8060006@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EAA39@DBDE04.ent.ti.com>
 <51B59C8B.9000405@ti.com>
In-Reply-To: <51B59C8B.9000405@ti.com>
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

Hi Benoit,

> -----Original Message-----
> From: Cousson, Benoit
> Sent: Monday, June 10, 2013 3:00 PM
> To: J, KEERTHY
> Cc: Stephen Warren; devicetree-discuss@lists.ozlabs.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> sameo@linux.intel.com; gg@slimlogic.co.uk; lee.jones@linaro.org
> Subject: Re: [PATCH] ARM: dts: add dtsi for palmas
> 
> Hi Keerthy,
> 
> On 06/10/2013 06:03 AM, J, KEERTHY wrote:
> > Hi Stephen,
> >
> > Thanks for the review comments.
> >
> > ________________________________________
> > From: Stephen Warren [swarren@wwwdotorg.org]
> > Sent: Saturday, June 08, 2013 1:26 AM
> > To: J, KEERTHY
> > Cc: Cousson, Benoit; devicetree-discuss@lists.ozlabs.org;
> > linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> > ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> > sameo@linux.intel.com; gg@slimlogic.co.uk; lee.jones@linaro.org
> > Subject: Re: [PATCH] ARM: dts: add dtsi for palmas
> >
> > On 06/07/2013 05:28 AM, J Keerthy wrote:
> >> Adds palmas mfd and palmas regulator nodes. This is based on the
> >> patch series:
> >>
> >> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg89957.html
> >>
> >> The device tree nodes are based on:
> >> https://lkml.org/lkml/2013/6/6/25
> >
> >> diff --git a/arch/arm/boot/dts/palmas.dtsi
> >> b/arch/arm/boot/dts/palmas.dtsi
> >
> >> +&palmas {
> >
> > Hmmm. That (i.e. requiring the board file to declare the node, then
> > setting up all the content by later including this file) is an
> > interesting approach. I guess it's reasonable. The one issue is that
> > it makes it a little harder for the board file to override any of the
> > properties in this file., although it certainly is possible by
> > including those overrides after the include.
> >
> > Irrespective of that, some comments on this:
> >
> >> +     palmas_pmic {
> >
> >> +             ti,ldo6-vibrator;
> >
> > For example, what if the board doesn't want to have the property set?
> >
> >> +
> >> +             regulators {
> >> +                     smps123_reg: smps123 {
> >> +                             regulator-name = "smps123";
> >> +                             regulator-min-microvolt = < 600000>;
> >> +                             regulator-max-microvolt = <1500000>;
> >
> > Or what if the board wants to limit the voltage range of this
> > regulator due to what it's used for on the board.
> >
> >> +                             regulator-always-on;
> >> +                             regulator-boot-on;
> >
> > And those two properties are almost certainly board-specific policy.
> >
> > Totally agree to all the above concerns. So can we have a custom
> .dtsi
> > file for a board+pmic combination? Or have only the required
> > properties over ridden in the board file?
> 
> Yes, you can do that potentially if most OMAP5 boards will reuse the
> same kind of settings. Kevin has just done that for OMAP3 + twl4030.
> 
> In this case, since we do have only one board, I'm not sure it worth
> the effort.

I sent a V2 with only the most generic property in palmas.dtsi and the
Configurable parameter under the board file. Let me know if that patch set
Is fine.


> 
> Regards,
> Benoit

Regards,
Keerthy
