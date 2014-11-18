Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaKRPhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:37:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:53872 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbaKRPhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:37:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="624289166"
Date: Tue, 18 Nov 2014 17:36:42 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautamvivek1987@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        andrew.kim@intel.com
Subject: Re: [PATCHv4 2/6] phy: improved lookup method
Message-ID: <20141118153642.GA8881@kuha.fi.intel.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1413556756-5050-3-git-send-email-heikki.krogerus@linux.intel.com>
 <CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com>
 <5461AFD3.5020302@ti.com>
 <CAFp+6iGJBSpA5+Q7WQVu0+y-mfoN-E+LmYedipVfgXFZOpr+Cw@mail.gmail.com>
 <5461CDDF.4090209@ti.com>
 <CAFp+6iGAQMgX8S6dfPO44U=r6QJ4fT+1FX2uHNF9KK4sYs+=XA@mail.gmail.com>
 <CAFp+6iHta15CuBbsoQxEo2xr5GyXDgXQ=cg_Q_vOSC7akX0Vcw@mail.gmail.com>
 <20141117154028.GD7512@kuha.fi.intel.com>
 <546AD6D6.5070205@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546AD6D6.5070205@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:49:18AM +0530, Kishon Vijay Abraham I wrote:
> On Monday 17 November 2014 09:10 PM, Heikki Krogerus wrote:
> > On Thu, Nov 13, 2014 at 07:03:01PM +0530, Vivek Gautam wrote:
> >> How about adding the change in attached patch [1] on top of this patch.
> >> Just introduced the phy pointer in "phy_lookup" structure, and
> >> modified phy_find() accordingly.
> > 
> > I would be fine if we used the phy pointer to match, but if we have
> > the pointer to the phy in the lookup, then I would say we need to
> > remove the phy_name member.
> > 
> > Otherwise we would have to support two ways of finding the lookups
> > (one for the "static" lookups where we match to the phy_name and other
> > where we match to the pointer). That means we will also not be able to
> > create "static" lookups, but those would be only needed if we wanted to
> > create them in board files. I don't think there will ever be need to
> > create the lookups in board files, so I'm more then happy to remove
> > the static way of creating the lookups.
> 
> Just using the phy pointer sounds good. But interested to know where the phy
> pointer will be added to the lookup table.

I'm making assumption that there will not be any (new) platforms where
the bindings are not provided in HW descriptions like dt or ACPI
tables. That leaves the lookups to be useful only in cases where a
driver has to, for whatever reason, pass it's phy's forward, like
dwc3 host. ULPI will be an other case where we will need to use them.

Now the only user for the lookups is twl4030-usb, but since it's
actually just ULPI type PHY in cases where we have platform data to
deal with (please correct me if I'm wrong), I think we could later
remove it's need for platform data completely with the help of the
ULPI bus I'm working with.


Cheers,

-- 
heikki
