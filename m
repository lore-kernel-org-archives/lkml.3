Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3GTQQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:16:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:61466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab3GTQQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:16:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,709,1367996400"; 
   d="scan'208";a="373704392"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH] x86, tboot: iomem fixes
Thread-Topic: [PATCH] x86, tboot: iomem fixes
Thread-Index: AQHOhOfd4PSVDZHDvEqU2XCxf2sMyJlsp1qAgAEVkjA=
Date: Sat, 20 Jul 2013 16:16:42 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE013CA85E@SHSMSX102.ccr.corp.intel.com>
References: <1374282787-30327-1-git-send-email-qiaowei.ren@intel.com>
 <20130720073459.GA5555@gmail.com>
In-Reply-To: <20130720073459.GA5555@gmail.com>
Accept-Language: zh-CN, en-US
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

On 2013-07-20, Ingo Molnar wrote:
> 
> * Qiaowei Ren <qiaowei.ren@intel.com> wrote:
> 
>> +#define SINIT_MLE_DATA_VTD_DMAR_OFF	140
> 
>>  	/* get addr of DMAR table */ +	dmar_tbl_off = readl(heap_ptr +
>>  SINIT_MLE_DATA_VTD_DMAR_OFF); 	dmar_tbl = (struct acpi_table_header
>>  *)(heap_ptr +
>> -		   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
>> -		   sizeof(u64));
>> +			dmar_tbl_off - sizeof(u64));
> 
> So the offset of ->vtd_dmars_off within struct sinit_mle_data is 140?
> 
> The new code is less readable: what's wrong with getting the offset
> automatically via C, instead of hardcoding it manually? You can use
> offsetof() primitive for increased readability.
> 
Ok. Thanks for your suggestion. I will try to use offsetof() to increase readability.

Thanks,
Qiaowei

