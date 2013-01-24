Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3AXN5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:57:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:19441 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3AXN5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:57:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,529,1355126400"; 
   d="scan'208";a="247913849"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [PATCH V3 1/2] Xen stub driver for memory hotplug
Thread-Topic: [PATCH V3 1/2] Xen stub driver for memory hotplug
Thread-Index: AQHN+aOWqS241vW3Tky5AAt8/VgAKZhYgUmg
Date: Thu, 24 Jan 2013 13:56:56 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DC766@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923353C24AD@SHSMSX101.ccr.corp.intel.com>
 <20130123195455.GA18022@phenom.dumpdata.com>
In-Reply-To: <20130123195455.GA18022@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/export.h>
>> +#include <linux/types.h>
>> +#include <linux/acpi.h>
>> +#include <acpi/acpi_drivers.h>
>> +#include <xen/acpi.h>
>> +
>> +/*--------------------------------------------
>> +	stub driver for Xen memory hotplug
>> +--------------------------------------------*/
>> +
>> +#ifdef CONFIG_ACPI
>> +
>> +static const struct acpi_device_id memory_device_ids[] = {
>> +	{ACPI_MEMORY_DEVICE_HID, 0},
>> +	{"", 0},
>> +};
>> +
>> +struct acpi_driver xen_stub_memory_device_driver = {
>> +	/* same name as native memory driver to block native loaded */
>> +	.name = "acpi_memhotplug", +	.class = ACPI_MEMORY_DEVICE_CLASS,
>> +	.ids = memory_device_ids,
>> +};
>> +EXPORT_SYMBOL_GPL(xen_stub_memory_device_driver);
> 
> Instead of having this, could you have a function that would
> unregister this if required.
> 
> xen_stub_memory_device_uninit(void)
> 
> which would unregister the above mentioned structure?
> 

Yup, updated by EXPORT_SYMBOL_GPL 2 funcs:
xen_stub_memory_device_init()
xen_stub_memory_device_exit()

Thanks,
Jinsong