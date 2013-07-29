Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3G2XI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:08:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:8759 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab3G2XI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:08:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,773,1367996400"; 
   d="scan'208";a="373130250"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: RE: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Topic: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Index: AQHOiIb0dT8QWA0joUSnTutOsRQJK5l0Aa0g///P94CAAE2lEP//9n6AgAW3aVCAAD6lgIACNeSQ///Tg4AABlua8A==
Date: Mon, 29 Jul 2013 23:08:52 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE77AB9@HASMSX106.ger.corp.intel.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
 <20130724160008.GA17083@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
 <20130724162605.GA9700@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
 <20130724202957.GA14913@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE76B1B@HASMSX106.ger.corp.intel.com>
 <20130728153155.GA6781@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE77A4E@HASMSX106.ger.corp.intel.com>
 <20130729223805.GA9677@kroah.com>
In-Reply-To: <20130729223805.GA9677@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > Just to make sure, is this what you're suggesting ?
> > > > > > > >
> > > > > > > > device->groups = mei_attr_groups
> > > > > > > > mei_misc_device.parent = device; ret =
> > > > > > > > misc_register(&mei_misc_device);
> > > > > > >
> > > > > > > Yes, that should work.  If not, please let me know, the code
> > > > > > > underwent some changes in 3.11-rc2.
> > > > > >
> > > > > > I don' t see the file being created.
> > > > > > Not sure if the  misc_register setup the parent sysfs as well.
> > > > >
> > > > > Oops, wait, the parent is already registered, that's not going
> > > > > to work, you want to create the files for the device itself that
> > > > > you are creating, so set the -
> > > > > >groups field for that device.
> > > > >
> > > > > sorry about that.
> > > >
> > > > So is this okay to go as  is?
> > >
> > > What is "this"?
> >
> > The intentions was to create the sysfs  on a  parent pci device, and
> > these are already created .
> 
> You can't create attributes on a device you do not "own", that will be racy
> and prone to cause big problems (your callback will not with the "right"
> device usually, as your parent might not "be" a pci device in the future...)
> 
> > The only reason I wanted do it here as this is true for any parent pci
> > device we support currently that registers with mei.
> >
> > Either this code ode is still confusing because  I'm  doing something
> > wrong here or  your mind Is set on fixing this particular user space
> > race issue.
> 
> Probably both...
> 
> Either way, you can't create sysfs files in a racy way, I'm going through the
> whole kernel tree to clean them all up, I'm not going to add new race
> conditions today that I need to fix up tomorrow, my patch count is high
> enough as it is :)

I understand your quest tough I'm asking you to throw some light on that
How do I add new device specific sysfs in non-race way if my entry point is the pci probe function.

Thanks
Tomas


