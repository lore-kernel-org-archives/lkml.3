Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaDCN76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:59:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:9983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbaDCN74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:59:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,787,1389772800"; 
   d="scan'208";a="506180528"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Linaro-acpi] How to pass I2C platform_data under ACPI
Thread-Topic: [Linaro-acpi] How to pass I2C platform_data under ACPI
Thread-Index: Ac9PFCVxc1BkxaEVQoqK2pGHEHD28f//1sIA//+iCPCAAOZ2Gv///osQ
Date: Thu, 3 Apr 2014 13:59:18 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD57464000@BGSMSX104.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
 <D854C92F57B1B347B57E531E78D05EAD57463D21@BGSMSX104.gar.corp.intel.com>
 <20140403113832.GD19349@intel.com> <4539649.rsMWK1FkZ6@wuerfel>
 <20140403135826.GF19349@intel.com>
In-Reply-To: <20140403135826.GF19349@intel.com>
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

>> > > And initialize the platform data in either driver or in separate 
>> > > module which gets compiled along with driver?
>> > 
>> > Typically it has been done in the same driver but I don't see any 
>> > problems having a separate module as well.
>> > 
>> > > static const struct acpi_device_id my_acpi_match[] = {
>> > >       { "MYID0001", (kernel_ulong_t)&my_platform_data1 }
>> > >       { "MYID0002", (kernel_ulong_t)&my_platform_data2 }
>> > >       ...
>> > >       { },
>> 
>> We definitely don't want per-board match entries, that does not scale.
>> The driver should be reasonably generic and get all the necessary data 
>> out of well-defined tables. You can have different IDs when there are 
>> only a few cases that are actually relevant, but it has to be 
>> conceivable that the same driver get used on future hardware without 
>> changes.
>
>Yes, I meant that when the platform data information is not available in ACPI namespace, then (and only then) pass the data by means of different IDs.
>
>Preferably this information is included in the ACPI namespace.

The idea is use the single platform_data struct  and initiaze it accordingly from the driver's __init call based on the board/platform.

Thanks for your inputs.
Ram.
