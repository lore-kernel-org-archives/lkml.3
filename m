Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3BSRpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:45:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:47235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784Ab3BSRpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:45:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="289155610"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: RE: How to populate Battery information through ACPI tables
Thread-Topic: How to populate Battery information through ACPI tables
Thread-Index: Ac4Oskyv9anm0zdmSXmuXEKAabFeBP//qGcA//+HEBCAAKCfAP//pGJQ
Date: Tue, 19 Feb 2013 17:45:38 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD2466187B@BGSMSX102.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD24661392@BGSMSX102.gar.corp.intel.com>
 <20130219152008.GG2439@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD2466175B@BGSMSX102.gar.corp.intel.com>
 <20130219174210.GH2439@intel.com>
In-Reply-To: <20130219174210.GH2439@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > On Tue, Feb 19, 2013 at 03:07:57PM +0000, Pallala, Ramakrishna wrote:
> > > > I am trying to populate battery related information through ACPI
> > > > tables and do battery management through non acpi drivers.  Can
> > > > you tell or point me on how to populate the ACPI tables in FW/BIOS
> > > > and get them in OS? I am new to ACPI world.
> > >
> > > You should start by reading Documentation/acpi/enumeration.txt.
> > >
> > > Also can you describe with bit more details, what you are trying to
> > > do? A new battery driver that is enumerated from ACPI namespace, perhaps?
> > >
> > > Do you have a DSDT table in hand which we could take a peek?
> >
> > Thanks Mika for the pointers. I have looked at the documentation.
> >
> > we already have i2c driver for battery monitoring but the chip needs
> > initialized with characterization data. We wanted to populate/pass
> > this data through ACPI table to the i2c slave driver.
> >
> > How can I do that? Can I pass characterization data through ACPI table
> > to the i2c slave device?
> 
> Is the characterization data available in DSDT (or SSDT) table? If yes, then you
> can just use the fact that ACPI_HANDLE(&i2c_client->dev) returns a valid ACPI
> handle for your device. You can use this handle to call some ACPI method or
> whaterver is needed to extract that information.

As of now this data is not there in any table. I want to put this data in DSDT table.
The data I want to put is specific to the device  and will be around 1K bytes.

One question, How the table and device are linked? Is it by device name/id?
Next, how to put this characterization data into the DSDT table?

Thanks,
Ram
