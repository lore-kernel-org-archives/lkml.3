Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaH3DsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:48:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:28827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaH3DsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378966628"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: David Miller <davem@davemloft.net>
CC: "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Rayagond K <rayagond@vayavyalabs.com>
Subject: RE: [PATCH 1/4] net: stmmac: enhance to support multiple device
 instances
Thread-Topic: [PATCH 1/4] net: stmmac: enhance to support multiple device
 instances
Thread-Index: AQHPwcrrXzTI3zohQ0CyXTCUnKuDb5vn9RCAgACJBcA=
Date: Sat, 30 Aug 2014 03:48:00 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B6E74EE@PGSMSX102.gar.corp.intel.com>
References: <cover.1409123378.git.hock.leong.kweh@intel.com>
	<cover.1409123378.git.hock.leong.kweh@intel.com>
	<cf29eb9e793cf67b99b455f3a4a55e7aca5d826c.1409123378.git.hock.leong.kweh@intel.com>
 <20140829.200623.1931173830496862001.davem@davemloft.net>
In-Reply-To: <20140829.200623.1931173830496862001.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.177.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Saturday, August 30, 2014 11:06 AM
> To: Kweh, Hock Leong
> Cc: peppe.cavallaro@st.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Ong, Boon Leong
> Subject: Re: [PATCH 1/4] net: stmmac: enhance to support multiple device
> instances
> 
> From: Kweh Hock Leong <hock.leong.kweh@intel.com>
> Date: Wed, 27 Aug 2014 18:32:26 +0800
> 
> > +static int instance_id = 1;
> 
> Don't do this instance stuff.  Instead pull in some identifier that
> can come from elsewhere.

Regarding this, I would like to open up a discussion here. This "instance_id" actually
is used for registering the mdio bus as a bus id. The original code use "1" for the bus
id. If the system plug in more than one stmmac pci cards, I believe there is conflict on
the mdio bus registration. So introduce this static global variable is to increase the
bus id starting from "1" base on how many stmmac pci cards being plugged in.

So, to change the "instance_id" by using some identifier, the only thing come to my
mind is pci_dev->devfn number. Is anyone have concern about using devfn number
as an mdio bus id ?


> > +	plat_dat->mdio_bus_data = devm_kzalloc(&pdev->dev,
> > +				    sizeof(*plat_dat->mdio_bus_data),
> > +				    GFP_KERNEL);
> 
> This is not indented properly.
> 
> On the second and subsequent lines of a multi-line function call,
> the lines should start exactly at the first column after the openning
> parenthesis of the first line.
> 
> You must use the correct number of TAB and SPACE characters necessary
> to do so.  Generally speaking, if you are indenting using only TAB
> characters, odds are you are doing it wrong.
> 
> Please audit for, and fix this, in your entire patch series.

Noted. Will fix the indentation on version 2 patch. Thanks.

