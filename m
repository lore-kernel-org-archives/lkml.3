Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaE0Xrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:47:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:5516 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaE0Xru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,923,1392192000"; 
   d="scan'208";a="545833699"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc-next 3/3] mei: add WPT second mei interface
Thread-Topic: [char-misc-next 3/3] mei: add WPT second mei interface
Thread-Index: AQHPefE8tqagw885w0+GVaVeBZ0JS5tU8GkA///ZPQCAAEVykA==
Date: Tue, 27 May 2014 23:47:44 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFFBE0A@HASMSX106.ger.corp.intel.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
 <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
 <20140527212207.GB26089@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFFBCDC@HASMSX106.ger.corp.intel.com>
 <20140527220630.GA7924@kroah.com>
In-Reply-To: <20140527220630.GA7924@kroah.com>
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



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, May 28, 2014 01:07
> To: Winkler, Tomas
> Cc: arnd@arndb.de; linux-kernel@vger.kernel.org; Usyskin, Alexander
> Subject: Re: [char-misc-next 3/3] mei: add WPT second mei interface
> 
> On Tue, May 27, 2014 at 09:42:19PM +0000, Winkler, Tomas wrote:
> > > > +/* PCH devices MEI 2 interface */
> > > > +const struct mei_cfg mei_me_pch_2_cfg = {
> > > > +	MEI_CFG_PCH_HFS,
> > > > +	.mei_id = 1
> > >
> > > That's going to be a recipe for disaster.  Have the MEI core allocate
> > > the id numbers as things are registered, don't have the individual
> > > drivers create their id.
> >
> > I'm don't think can ensure the enumeration order.
> 
> You should not be relying on the order to get anything right.
> 
> > This is per device not per driver configuration structure.
> > Each pci device is actually just  another head to one MEI device but heads are not
> equal the name/id matters
> > Yes I assume it looks odd at the first glance, anyhow we are open to any
> reasonable suggestions
> 
> Just dynamically allocate the numbers like all other subsystems do?
>
> Then userspace can open the device nodes it cares about, it should be
> able to somehow tell what device is what somehow, right?  If not, you
> are doing something wrong with the interface as you can't rely on minor
> numbers.
> 

The only way for user space to distinguish among interfaces is the same way as driver does by looking for device id. 
The assignment of the device name/id is pretty much static in the HW. Now the same device id database from the driver has to be copied 
to the udev rules or equivalent  and kept in sync.   
Most importantly all the legacy user space just opens /dev/mei  so I wanted to leave /dev/mei (not /dev/mei0) to be assigned always to the first mei head and to not break existing user space. 

Can you be a bit more specific on why we cannot depend on minor numbers and default naming rules, what is the scenario that will break? 

Thanks
Tomas

