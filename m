Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3LFUFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:05:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:43102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab3LFUFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:05:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="448150607"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Xudong Hao <xudong.hao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
Thread-Topic: [Qemu-devel] [PATCH v2 3/3] X86,	mpx: Intel MPX xstate feature
 definition
Thread-Index: AQHO8qmoYnj+nqsDeUCT31iTRUZtSppHhNfw
Date: Fri, 6 Dec 2013 20:05:19 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350140B3B6@SHSMSX101.ccr.corp.intel.com>
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com>
	<1386375658-2191-3-git-send-email-qiaowei.ren@intel.com>
 <52A20AD6.8080706@redhat.com>
In-Reply-To: <52A20AD6.8080706@redhat.com>
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

Paolo Bonzini wrote:
> Il 07/12/2013 01:20, Qiaowei Ren ha scritto:
>> This patch defines xstate feature and extends struct xsave_hdr_struct
>> to support Intel MPX.
>> 
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
>> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
>> ---
>>  arch/x86/include/asm/processor.h |   12 ++++++++++++
>>  arch/x86/include/asm/xsave.h     |    5 ++++-
>>  2 files changed, 16 insertions(+), 1 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/processor.h
>> b/arch/x86/include/asm/processor.h index 987c75e..2fe2e75 100644 ---
>> a/arch/x86/include/asm/processor.h +++
>> b/arch/x86/include/asm/processor.h @@ -370,6 +370,15 @@ struct
>>  	ymmh_struct { u32 ymmh_space[64];
>>  };
>> 
>> +struct bndregs_struct {
>> +	u64 bndregs[8];
>> +} __packed;
>> +
>> +struct bndcsr_struct {
>> +	u64 cfg_reg_u;
>> +	u64 status_reg;
>> +} __packed;
>> +
>>  struct xsave_hdr_struct {
>>  	u64 xstate_bv;
>>  	u64 reserved1[2];
>> @@ -380,6 +389,9 @@ struct xsave_struct {
>>  	struct i387_fxsave_struct i387;
>>  	struct xsave_hdr_struct xsave_hdr;
>>  	struct ymmh_struct ymmh;
>> +	u8 lwp_area[128];
> 
> Sorry for the back-and-forth, but I think this and the removal of
> XSTATE_FLEXIBLE (perhaps XSTATE_LAZY?) makes your v2 worse than v1.
> 
> Since Peter already said the same, please undo these changes.
> 
> Also, how is XSTATE_EAGER used?  Should MPX be disabled when xsaveopt
> is disabled on the kernel command line?  (Liu, how would this affect
> the KVM patches, too?)
> 
> Paolo

Currently seems no, and if needed we can add a new patch at kvm side accordingly when native mpx patches checked in.

Jinsong

> 
>> +#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)  /*
>>   * These are the features that the OS can handle currently.   */
>> -#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
>> +#define XCNTXT_MASK    (XSTATE_FP | XSTATE_SSE | XSTATE_YMM |
>> XSTATE_EAGER) 
>> 
>>  #ifdef CONFIG_X86_64
>>  #define REX_PREFIX	"0x48, "

