Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3AYGcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:32:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:13310 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3AYGcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:32:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,536,1355126400"; 
   d="scan'208";a="252201368"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [PATCH V1 1/3] Xen stub driver for CPU hotplug
Thread-Topic: [PATCH V1 1/3] Xen stub driver for CPU hotplug
Thread-Index: AQHN+aOt6Xsp16l+jUKGKBoaLOSoKphZl6Pw
Date: Fri, 25 Jan 2013 06:32:41 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD417@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923353C3DB4@SHSMSX101.ccr.corp.intel.com>
 <20130123195530.GB18022@phenom.dumpdata.com>
In-Reply-To: <20130123195530.GB18022@phenom.dumpdata.com>
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

Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 15, 2013 at 12:30:19PM +0000, Liu, Jinsong wrote:
>>> From 110b4ef3b8ebefeaf68832dd8ef8aa916a782e89 Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu Jinsong <jinsong.liu@intel.com>
>> Date: Mon, 14 Jan 2013 15:19:30 +0800
>> Subject: [PATCH 1/3] Xen stub driver for CPU hotplug
>> 
>> Add Xen stub driver for CPU hotplug, early occupy to block native,
>> will be replaced later by real Xen processor driver module.
>> 
>> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
>> ---
>>  drivers/xen/xen-stub.c |   34 ++++++++++++++++++++++++++++++++--
>>  include/xen/acpi.h     |    6 ++++++
>>  2 files changed, 38 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
>> index 01a49e3..681e9cc 100644
>> --- a/drivers/xen/xen-stub.c
>> +++ b/drivers/xen/xen-stub.c
>> @@ -28,12 +28,13 @@
>>  #include <acpi/acpi_drivers.h>
>>  #include <xen/acpi.h>
>> 
>> +
>> +#ifdef CONFIG_ACPI
>> +
>>  /*--------------------------------------------
>>  	stub driver for Xen memory hotplug
>>  --------------------------------------------*/
>> 
>> -#ifdef CONFIG_ACPI
>> -
>>  static const struct acpi_device_id memory_device_ids[] = {
>>  	{ACPI_MEMORY_DEVICE_HID, 0},
>>  	{"", 0},
>> @@ -57,4 +58,33 @@ static int __init
>>  xen_stub_memory_device_init(void)  }
>> subsys_initcall(xen_stub_memory_device_init); 
>> 
>> +
>> +/*--------------------------------------------
>> +	stub driver for Xen cpu hotplug
>> +--------------------------------------------*/
>> +
>> +static const struct acpi_device_id processor_device_ids[] = {
>> +	{ACPI_PROCESSOR_OBJECT_HID, 0},
>> +	{ACPI_PROCESSOR_DEVICE_HID, 0},
>> +	{"", 0},
>> +};
>> +
>> +struct acpi_driver xen_stub_processor_driver = {
>> +	/* same name as native processor driver to block native loaded */
>> +	.name = "processor", +	.class = ACPI_PROCESSOR_CLASS,
>> +	.ids = processor_device_ids,
>> +};
>> +EXPORT_SYMBOL_GPL(xen_stub_processor_driver);
> 
> Could you make this be
> 
> xen_stub_processor_deinit() instead?
> 

Updated, w/ 2 funcs EXPORT_SYMBOL_GPL to cpu hotplug module:
xen_stub_processor_init()
xen_stub_processor_exit()

Thanks,
Jinsong