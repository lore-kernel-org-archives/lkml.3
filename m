Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985Ab3FSB2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:28:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38125 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab3FSB2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:28:52 -0400
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
Subject: RE: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property exists
 and then only request irq
Thread-Topic: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property
 exists and then only request irq
Thread-Index: AQHObAxY8SVidqm7fEWvMR88AcSmApk7GTuAgACV5XD//3+CgIAAhmbw//99ooCAAIbxQP//l5UAAB3a8TA=
Date: Wed, 19 Jun 2013 01:28:31 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EC65B@DBDE04.ent.ti.com>
References: <1371549692-7361-1-git-send-email-j-keerthy@ti.com>
 <1371549692-7361-2-git-send-email-j-keerthy@ti.com>
 <51C0820B.4020404@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EC563@DBDE04.ent.ti.com>
 <51C093FF.6000204@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EC5B4@DBDE04.ent.ti.com>
 <51C09761.1020704@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229EC5DB@DBDE04.ent.ti.com>
 <51C0B0FC.2090908@wwwdotorg.org>
In-Reply-To: <51C0B0FC.2090908@wwwdotorg.org>
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
> Sent: Wednesday, June 19, 2013 12:42 AM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
> ldewangan@nvidia.com; sameo@linux.intel.com; grant.likely@secretlab.ca;
> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property
> exists and then only request irq
> 
> On 06/18/2013 11:33 AM, J, KEERTHY wrote:
> > Stephen Warren wrote at Tuesday, June 18, 2013 10:53 PM:
> ...>> No, you should just check the IRQ number.
> >
> > Hmmm...so something like (!i2c->irq)
> 
> Yes.

Ok.

> 
> >> Consider this:
> >>
> >> If the device was instantiated from a board file *or* a device tree,
> >> i2c->irq is correctly set. Hence, checking that value works in both
> >> cases.
> >>
> >> If you check the interrupts DT property, that will only work if the
> >> device was instantiated from device tree, and not if it was
> >> instantiated from a board file; the property will never exist in the
> >> board file case, and hence you'll never be able to have a board file
> >> provide an interrupt.
> >
> > The board file approach is getting deprecated for this. I Myself
> > removed board file related pdata stuff in one of the patches.
> >
> > http://www.mail-archive.com/linux-omap@vger.kernel.org/msg90598.html
> >
> > So going the DeviceTree way.
> 
> Even if you're 100% sure this driver will only ever work with DT (which
> seems like a bad assumption to make no matter what the circumstance),
> it'd still be best to detect whether an IRQ was specified in a generic
> way. That way, nobody will read this driver, assume the code is
> generic, and just copy/paste it without thinking.

Ok. I understand. I will incorporate this.

Thanks,
Keerthy
