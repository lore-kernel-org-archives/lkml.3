Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaIMHYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 03:24:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:11337 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaIMHYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 03:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,516,1406617200"; 
   d="scan'208";a="590772711"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 04/10] x86, mpx: hook #BR exception handler to
 allocate bound tables
Thread-Topic: [PATCH v8 04/10] x86, mpx: hook #BR exception handler to
 allocate bound tables
Thread-Index: AQHPzZ39TaJtkyLCw0+7mvJhgdztCpv9mKiAgAESXmA=
Date: Sat, 13 Sep 2014 07:24:02 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017A5821@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-5-git-send-email-qiaowei.ren@intel.com>
 <54137A79.6060602@intel.com>
In-Reply-To: <54137A79.6060602@intel.com>
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



On 2014-09-13, Hansen, Dave wrote:
> On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
>> +static int allocate_bt(long __user *bd_entry) {
>> +	unsigned long bt_addr, old_val = 0;
>> +	int ret = 0;
>> +
>> +	bt_addr = mpx_mmap(MPX_BT_SIZE_BYTES);
>> +	if (IS_ERR((void *)bt_addr))
>> +		return bt_addr;
>> +	bt_addr = (bt_addr & MPX_BT_ADDR_MASK) |
> MPX_BD_ENTRY_VALID_FLAG;
> 
> Qiaowei, why do we need the "& MPX_BT_ADDR_MASK" here?

It should be not necessary, and can be removed.

Thanks,
Qiaowei
