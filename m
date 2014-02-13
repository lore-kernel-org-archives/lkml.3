Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBMXfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:35:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:62923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaBMXfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:35:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,841,1384329600"; 
   d="scan'208";a="455182289"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [PATCH 2/2] ACPICA: acpidump: Remove translation protection on
 integer types.
Thread-Topic: [PATCH 2/2] ACPICA: acpidump: Remove translation protection on
 integer types.
Thread-Index: AQHPJtQ+83wKMlZJs0qaz7pkUBWX1JqzA5cAgADOxbA=
Date: Thu, 13 Feb 2014 23:34:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31DC88AC@ORSMSX106.amr.corp.intel.com>
References: <cover.1392086457.git.lv.zheng@intel.com>
 <55e016394ee9d4291e8c42e00383c93a3ace4b0b.1392086457.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024B004C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024B004C@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    All definitions are equal except ACPI_UINT64_MAX for CONFIG_IA64.  It
>    is changed from sizeof(unsigned long) to sizeof(unsigned long long).
>    By investigation, 64bit Linux kernel build is LP64 compliant, i.e.,
>    sizeof(long) and (pointer) are 64.  As sizeof(unsigned long) equals to
>    sizeof(unsigned long long) on IA64 platform where CONFIG_64BIT cannot be
>    disabled, this change actually will not affect the value of
>    ACPI_UINT64_MAX on IA64 platforms.

This all looks correct to me - it really shouldn't make any difference
to ia64 whether we use "long" or "long long" ... both are 8-byte entities.
The compiler would complain in some places if you mixed & matched
incorrectly (e.g. printk("val = %ld\n", val); will give a warning if val has
been switched from "long" to "long long" and the format would need
to change to "%lld").  But it looks like nothing like that happens as a
result of this patch. All my ia64 configs build with no new warnings.

Boots OK too.

-Tony
