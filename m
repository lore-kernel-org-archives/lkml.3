Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaE0Vo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:44:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:57243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaE0VoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,922,1392192000"; 
   d="scan'208";a="518627466"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc-next 3/3] mei: add WPT second mei interface
Thread-Topic: [char-misc-next 3/3] mei: add WPT second mei interface
Thread-Index: AQHPefE8tqagw885w0+GVaVeBZ0JS5tU8GkA
Date: Tue, 27 May 2014 21:42:19 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFFBCDC@HASMSX106.ger.corp.intel.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
 <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
 <20140527212207.GB26089@kroah.com>
In-Reply-To: <20140527212207.GB26089@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/* PCH devices MEI 2 interface */
> > +const struct mei_cfg mei_me_pch_2_cfg = {
> > +	MEI_CFG_PCH_HFS,
> > +	.mei_id = 1
> 
> That's going to be a recipe for disaster.  Have the MEI core allocate
> the id numbers as things are registered, don't have the individual
> drivers create their id.

I'm don't think can ensure the enumeration order.
This is per device not per driver configuration structure.
Each pci device is actually just  another head to one MEI device but heads are not equal the name/id matters
Yes I assume it looks odd at the first glance, anyhow we are open to any reasonable suggestions 
 

> > diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> > index c58e059..cf4ed5a 100644
> > --- a/drivers/misc/mei/main.c
> > +++ b/drivers/misc/mei/main.c
> > @@ -667,7 +667,7 @@ int mei_register(struct mei_device *dev)
> >  {
> >
> >  	int ret, devno;
> > -	int id = 0; /* FIXME: retrieve interface version*/
> > +	int id = dev->cfg->mei_id;
> 
> Why can't you do this in patch 01 of this series?

It was just progress of development we can refactor that, no problem 
> 
> 
> >
> >  	/* Fill in the data structures */
> >  	devno = MKDEV(MAJOR(mei_devt), id);
> > diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
> > index a418565..a521783 100644
> > --- a/drivers/misc/mei/mei_dev.h
> > +++ b/drivers/misc/mei/mei_dev.h
> > @@ -384,10 +384,12 @@ enum mei_pg_state {
> >   *
> >   * @fw_status - FW status
> >   * @quirk_probe - device exclusion quirk
> > + * @mei_id - id of mei device
> >   */
> >  struct mei_cfg {
> >  	const struct mei_fw_status fw_status;
> >  	bool (*quirk_probe)(struct pci_dev *pdev);
> > +	int mei_id;
> 
> This should be part of the device, not the configuration, for the reason
> specified above.

As stated above this is per devices configuration.



Thanks
Tomas
