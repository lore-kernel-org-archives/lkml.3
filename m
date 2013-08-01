Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3HAHVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:21:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:45667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab3HAHVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,792,1367996400"; 
   d="scan'208";a="339952008"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: RE: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Topic: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Index: AQHOiIb0dT8QWA0joUSnTutOsRQJK5l0Aa0g///P94CAAE2lEP//9n6AgAW3aVCAAD6lgIACNeSQ///Tg4AABlua8P//2B8A//wl5LA=
Date: Thu, 1 Aug 2013 07:21:30 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE7AC90@HASMSX106.ger.corp.intel.com>
References: <20130724160008.GA17083@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
 <20130724162605.GA9700@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
 <20130724202957.GA14913@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE76B1B@HASMSX106.ger.corp.intel.com>
 <20130728153155.GA6781@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE77A4E@HASMSX106.ger.corp.intel.com>
 <20130729223805.GA9677@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE77AB9@HASMSX106.ger.corp.intel.com>
 <20130729231724.GA10863@kroah.com>
In-Reply-To: <20130729231724.GA10863@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Mon, Jul 29, 2013 at 11:08:52PM +0000, Winkler, Tomas wrote:
> > How do I add new device specific sysfs in non-race way if my entry
> > point is the pci probe function.
> 
> You do it in the device creation for the device you add below the PCI device
> in sysfs, by setting the groups field in the device.
> 
> You don't create files in the sysfs directory for the PCI device itself, those are
> owned by the PCI bus core.
> 
> This is why you are your own "bus" here, use it :)

> If you still have questions, how about we take it to code, post what you have,
> and I'll see what needs to be changed.
> 
> hope this helps,

Right but this is not related to mei_cl_bus,  which is an abstraction in MEI protocol level, I wanted to augment the pci device.

We'd I've tried to expose is the FW status register from pci config space, (I' know the pci config space
Is already exposed through syfs), the issue is that the  offset of the registers changes between different HW, so I wished that there
Is a sysfs entry called fw_status  always points to the correct offset.  An application that tries to query fw status can be oblivious to underlying HW SKU. 

I guess that sysfs is not good interface for that now.  I will just resend the two other patches w/o sysfs 

Thanks
Tomas


