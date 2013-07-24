Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3GXQVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:21:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:37539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab3GXQVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="272646831"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: RE: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Topic: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Index: AQHOiIb0dT8QWA0joUSnTutOsRQJK5l0Aa0g
Date: Wed, 24 Jul 2013 16:20:32 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
 <20130724160008.GA17083@kroah.com>
In-Reply-To: <20130724160008.GA17083@kroah.com>
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



> >  int mei_register(struct mei_device *dev)  {
> > +	struct device *device = &dev->pdev->dev;
> >  	int ret;
> > -	mei_misc_device.parent = &dev->pdev->dev;
> > +
> > +	mei_misc_device.parent = device;
> >  	ret = misc_register(&mei_misc_device);
> >  	if (ret)
> >  		return ret;
> >
> > +	ret = sysfs_create_group(&device->kobj, &mei_attr_group);
> > +	if (ret)
> > +		return ret;
> 

> And you just lost the race with userspace (you told it you had a device, it
> went and scanned your attributes and saved them, then you registered
> more...)
> 
> Please use the dev_groups field for your class to properly have the driver
> core register these before userspace is told about the device, that's the
> correct way to do this.

Just to make sure, is this what you're suggesting ?

device->groups = mei_attr_groups
mei_misc_device.parent = device;
ret = misc_register(&mei_misc_device);

Thanks
Tomas 

