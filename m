Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3AYGjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:39:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:57686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab3AYGjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:39:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,536,1355126400"; 
   d="scan'208";a="252202967"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [PATCH V1 3/3] Xen processor driver
Thread-Topic: [PATCH V1 3/3] Xen processor driver
Thread-Index: AQHN+aRdkgXro0StTUilZtEGnrJ9O5hZmFbw
Date: Fri, 25 Jan 2013 06:39:28 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD432@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923353C3DE6@SHSMSX101.ccr.corp.intel.com>
 <20130123200023.GC18022@phenom.dumpdata.com>
In-Reply-To: <20130123200023.GC18022@phenom.dumpdata.com>
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

Agree, with minor comments below.

Konrad Rzeszutek Wilk wrote:
>> 
>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>> index 2dc7022..ca2535a 100644
>> --- a/drivers/xen/Kconfig
>> +++ b/drivers/xen/Kconfig
>> @@ -202,6 +202,18 @@ config XEN_ACPI_HOTPLUG_MEMORY
>>  	  to hot-add memory at runtime (the hot-added memory cannot be
>>  	  removed until machine stop), select Y/M here, otherwise select N.
>> 
>> +config XEN_PROCESSOR
> 
> I think the name should be XEN_ACPI_PROCESSOR but then the
> xen-acpi-processor gets in the way.  Hm, perhaps this should be then
> called xen-acpi-cpu-hotplug.c ?
> 
> Would that work?
> 
> Or xen-acpi-cpu.c?
> 
> So then it is called 'XEN_ACPI_CPU' ?

So let's use xen-acpi-cpuhoplut.c and XEN_ACPI_HOTPLUG_CPU,
compared with xen memory hotplug xen-acpi-memhotplug.c and XEN_ACPI_HOTPLUG_MEMORY

> 
> 
>> +	tristate "Xen processor driver"
>> +	depends on XEN_STUB && ACPI
> 
> Is there anytime a scenario where the user might compile a kernel
> without DOM0 support, but with Xen_stub && ACPI?

Hmm, let's relax xen-stub.c by 'depends on XEN'
and for xen cpu/mem hotplug add 'depends on XEN_DOM0'

Thanks,
Jinsong