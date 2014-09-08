Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaIHDMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 23:12:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:56847 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaIHDMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 23:12:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,484,1406617200"; 
   d="scan'208";a="596054336"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: "'David Miller'" <davem@davemloft.net>
CC: "'peppe.cavallaro@st.com'" <peppe.cavallaro@st.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "'Rayagond K'" <rayagond@vayavyalabs.com>
Subject: RE: [PATCH 1/4] net: stmmac: enhance to support multiple device
 instances
Thread-Topic: [PATCH 1/4] net: stmmac: enhance to support multiple device
 instances
Thread-Index: AQHPwcrrXzTI3zohQ0CyXTCUnKuDb5vn9RCAgACJBcCADhmvoA==
Date: Mon, 8 Sep 2014 03:10:43 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B7E8827@PGSMSX102.gar.corp.intel.com>
References: <cover.1409123378.git.hock.leong.kweh@intel.com>
	<cover.1409123378.git.hock.leong.kweh@intel.com>
	<cf29eb9e793cf67b99b455f3a4a55e7aca5d826c.1409123378.git.hock.leong.kweh@intel.com>
 <20140829.200623.1931173830496862001.davem@davemloft.net>
 <F54AEECA5E2B9541821D670476DAE19C2B6E74EE@PGSMSX102.gar.corp.intel.com>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B6E74EE@PGSMSX102.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kweh, Hock Leong
> Sent: Saturday, August 30, 2014 11:48 AM
> To: David Miller
> Cc: peppe.cavallaro@st.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Ong, Boon Leong; Rayagond K
> Subject: RE: [PATCH 1/4] net: stmmac: enhance to support multiple device
> instances
> 
> > From: David Miller [mailto:davem@davemloft.net]
> > Sent: Saturday, August 30, 2014 11:06 AM
> > > From: Kweh Hock Leong <hock.leong.kweh@intel.com>
> > >Date: Wed, 27 Aug 2014 18:32:26 +0800
> > >
> > > +static int instance_id = 1;
> >
> > Don't do this instance stuff.  Instead pull in some identifier that
> > can come from elsewhere.
> 
> Regarding this, I would like to open up a discussion here. This "instance_id"
> actually is used for registering the mdio bus as a bus id. The original code use
> "1" for the bus id. If the system plug in more than one stmmac pci cards, I
> believe there is conflict on the mdio bus registration. So introduce this static
> global variable is to increase the bus id starting from "1" base on how many
> stmmac pci cards being plugged in.
> 
> So, to change the "instance_id" by using some identifier, the only thing come
> to my mind is pci_dev->devfn number. Is anyone have concern about using
> devfn number as an mdio bus id ?

Hi David and everyone,

Just gently ping to see if any concern about the above discussion that
removing the instance_id and use the PCI_DEVID number for the mdio bus
number registration as showed below:

-static void stmmac_default_data(void)
+static void stmmac_default_data(struct plat_stmmacenet_data *plat_dat,
+                                                                   struct pci_dev *pdev)
 {
-       plat_dat.bus_id = 1;
+       plat_dat->bus_id = PCI_DEVID(pdev->bus->number, pdev->devfn);


Looking forward to get inputs from you guys. I will send the 2nd version
by this Wed if no one have concern to this. Thanks.


Regards,
Wilson
