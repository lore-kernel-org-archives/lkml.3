Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaIMHNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 03:13:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:51165 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaIMHNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 03:13:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="385593694"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 06/10] mips: sync struct siginfo with general version
Thread-Topic: [PATCH v8 06/10] mips: sync struct siginfo with general version
Thread-Index: AQHPzZ3931dm6xZeOUipzzIY4nUd/5v7+eYAgADSLcD//9avAIACBcOA
Date: Sat, 13 Sep 2014 07:13:02 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017A5800@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-7-git-send-email-qiaowei.ren@intel.com>
 <alpine.DEB.2.10.1409120007550.4178@nanos>
 <9E0BE1322F2F2246BD820DA9FC397ADE017A3FF0@shsmsx102.ccr.corp.intel.com>
 <alpine.DEB.2.10.1409121015070.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121015070.4178@nanos>
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



On 2014-09-12, Thomas Gleixner wrote:
> On Fri, 12 Sep 2014, Ren, Qiaowei wrote:
>> On 2014-09-12, Thomas Gleixner wrote:
>>> On Thu, 11 Sep 2014, Qiaowei Ren wrote:
>>> 
>>>> Due to new fields about bound violation added into struct
>>>> siginfo, this patch syncs it with general version to avoid build issue.
>>> 
>>> You completely fail to explain which build issue is addressed by
>>> this patch. The code you added to kernel/signal.c which accesses
>>> _addr_bnd is guarded by
>>> 
>>> +#ifdef SEGV_BNDERR
>>> 
>>> which is not defined my MIPS. Also why is this only affecting MIPS
>>> and not any other architecture which provides its own struct siginfo ?
>>> 
>>> That patch makes no sense at all, at least not without a proper explanation.
>>> 
>> For arch=mips, siginfo.h (arch/mips/include/uapi/asm/siginfo.h) will
>> include general siginfo.h, and only replace general stuct siginfo
>> with mips specific struct siginfo. So SEGV_BNDERR will be defined
>> for all archs, and we will get error like "no _lower in struct
>> siginfo" when arch=mips.
>> 
>> In addition, only MIPS arch define its own struct siginfo, so this
>> is only affecting MIPS.
> 
> So IA64 does not count as an architecture and therefor does not need
> the same treatment, right?
> 
struct siginfo for IA64 should be also synced. I will do this next post.

Thanks,
Qiaowei

