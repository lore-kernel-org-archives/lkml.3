Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaDCLZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:25:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:61261 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaDCLZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:25:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,786,1389772800"; 
   d="scan'208";a="513630732"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: How to pass I2C platform_data under ACPI
Thread-Topic: How to pass I2C platform_data under ACPI
Thread-Index: Ac9PFCVxc1BkxaEVQoqK2pGHEHD28f//1sIA//+iCPA=
Date: Thu, 3 Apr 2014 11:25:34 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD57463D21@BGSMSX104.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
 <20140403111240.GC19349@intel.com>
In-Reply-To: <20140403111240.GC19349@intel.com>
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

>> In non ACPI environment I used to initialize the platform_data under 
>> board or platforms files. Under ACPI how do I do that?
>
>If you can't extract that information from ACPI namespace, then one option is to pass platform data along with the device ACPI ID:
>
>static const struct acpi_device_id my_acpi_match[] = {
>	{ "MYID0001", (kernel_ulong_t)&my_platform_data }
>	...
>	{ },
>};

Thanks for the Quick reply.

So If I  want to use different platform_data for different boards can I do something like below?
And initialize the platform data in either driver or in separate module which gets compiled along with driver?

static const struct acpi_device_id my_acpi_match[] = {
	{ "MYID0001", (kernel_ulong_t)&my_platform_data1 }
	{ "MYID0002", (kernel_ulong_t)&my_platform_data2 }
	...
	{ },

Thanks,
Ram
