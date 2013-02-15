Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3BORUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:20:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:57182 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3BORUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,674,1355126400"; 
   d="scan'208";a="291733466"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: linux-next: build failure after merge of the xen-two tree
Thread-Topic: linux-next: build failure after merge of the xen-two tree
Thread-Index: AQHOC4AoTyBHFMmDoE2LH83uWllZQ5h7KcvQ
Date: Fri, 15 Feb 2013 17:20:07 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353FBF85@SHSMSX101.ccr.corp.intel.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
 <20130215132624.GB11777@phenom.dumpdata.com>
In-Reply-To: <20130215132624.GB11777@phenom.dumpdata.com>
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
> On Fri, Feb 15, 2013 at 03:45:51PM +1100, Stephen Rothwell wrote:
>> Hi Konrad,
>> 
>> After merging the xen-two tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
> 
> Good morning!
>> 
>> drivers/xen/xen-acpi-memhotplug.c: In function
>> 'acpi_memory_get_device': 
>> drivers/xen/xen-acpi-memhotplug.c:191:2: error: implicit declaration
>> of function 'acpi_bus_add' [-Werror=implicit-function-declaration]
>> drivers/xen/xen-acpi-memhotplug.c: At top level: 
>> drivers/xen/xen-acpi-memhotplug.c:417:3: warning: initialization
>> from incompatible pointer type [enabled by default]
>> drivers/xen/xen-acpi-memhotplug.c:417:3: warning: (near
>> initialization for 'xen_acpi_memory_device_driver.ops.remove')
>> [enabled by default]   
>> 
>> Caused by commit 259f201cb7ea ("xen/acpi: ACPI memory hotplug").
>> 
>> drivers/xen/xen-acpi-cpuhotplug.c: In function
>> 'acpi_processor_device_add': 
>> drivers/xen/xen-acpi-cpuhotplug.c:254:2: error: implicit declaration
>> of function 'acpi_bus_add' [-Werror=implicit-function-declaration]
>> drivers/xen/xen-acpi-cpuhotplug.c: At top level: 
>> drivers/xen/xen-acpi-cpuhotplug.c:425:3: warning: initialization
>> from incompatible pointer type [enabled by default]
>> drivers/xen/xen-acpi-cpuhotplug.c:425:3: warning: (near
>> initialization for 'xen_acpi_processor_driver.ops.remove') [enabled
>> by default]   
>> 
>> Caused by commit 181232c249f0 ("xen/acpi: ACPI cpu hotplug").
> 
> Grrrreat! Jinsong, can you please fix that ? A patch on top of the
> #linux-next
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git 

Done, warning fixed.

Thanks,
Jinsong