Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3FRFP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:15:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38260 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3FRFPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:15:25 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH 1/4] MFD: Palmas: Add Interrupt feature
Thread-Topic: [PATCH 1/4] MFD: Palmas: Add Interrupt feature
Thread-Index: AQHOa1SCNVc0IQ+tOESZXhHQVgzvJ5k5jzWAgAFL/hA=
Date: Tue, 18 Jun 2013 05:15:03 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EC277@DBDE04.ent.ti.com>
References: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
 <1371470954-9124-2-git-send-email-j-keerthy@ti.com>
 <20130617161615.GH1403@sirena.org.uk>
In-Reply-To: <20130617161615.GH1403@sirena.org.uk>
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

Hi Mark,

Thanks for the review.

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Monday, June 17, 2013 9:46 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; ldewangan@nvidia.com;
> sameo@linux.intel.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org;
> gg@slimlogic.co.uk
> Subject: Re: [PATCH 1/4] MFD: Palmas: Add Interrupt feature
> 
> On Mon, Jun 17, 2013 at 05:39:11PM +0530, J Keerthy wrote:
> 
> > Palmas PMICs have an INT line. This line is one single Interrupt line
> > to the application processor. The interrupt feature enables to
> > selectively request irq for only those specific chips which have INT
> > line connected to a valid IRQ line of the application processor.
> 
> Does the support for the interrupt line need to be explicitly flagged
> like this or can the driver not simply support an interrupt line not
> being configured?  That would also support cases where the hardware has
> an interrupt line but the system integrator has opeted not to connect
> it for some reason which seems generally more flexible than doing
> things on a chip ID basis.
> 

I understand your point. The IRQ is passed from device tree node.
Say if the chip for some reason is not connected to any valid
IRQ line the driver might end up requesting for a wrong IRQ line.

So should I be validating the irq entry populated from  device tree?

Explicitly checking on chip ID helps to avoid wrongly populated
Device tree data. 

> > +/**
> > + * DOC: Palmas PMIC feature types
> > + *
> 
> Is "DOC: " normal kerneldoc?

Normal kerneldoc I shall remove "DOC:"

Regards,
Keerthy
