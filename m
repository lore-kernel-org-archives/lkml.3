Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaILDKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:10:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:18048 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaILDKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:10:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="385070359"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Topic: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Index: AQHPzZ3/3LbWETWFOEu3f3vsawDskpv7gbqAgAFQ9kA=
Date: Fri, 12 Sep 2014 03:10:37 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017A403C@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
 <5411B9BD.2000900@intel.com>
In-Reply-To: <5411B9BD.2000900@intel.com>
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



On 2014-09-11, Hansen, Dave wrote:
> On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
>> +
>> +	return (void __user *)(unsigned long)(xsave_buf->bndcsr.cfg_reg_u &
>> +			MPX_BNDCFG_ADDR_MASK);
>> +}
> 
> I don't think casting a u64 to a ulong, then to a pointer is useful.
> Just take the '(unsigned long)' out.

If so, this will spits out a warning on 32-bit:

arch/x86/kernel/mpx.c: In function 'task_get_bounds_dir':
arch/x86/kernel/mpx.c:21:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Thanks,
Qiaowei

