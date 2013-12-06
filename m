Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab3LFRXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:23:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58823 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab3LFRXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:23:54 -0500
Message-ID: <52A2080A.9010208@zytor.com>
Date: Fri, 06 Dec 2013 09:23:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH 3/3] X86, mpx: Intel MPX xstate feature definition
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com> <1386355976-11732-3-git-send-email-qiaowei.ren@intel.com> <20131206134631.GD6694@pd.tnic>
In-Reply-To: <20131206134631.GD6694@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 05:46 AM, Borislav Petkov wrote:
> 
> I'm guessing this and the struct lwp_struct above is being added so that
> you can have the LWP XSAVE area size? If so, you don't need it: LWP
> XSAVE area is 128 bytes at offset 832 according to my manuals so I'd
> guess having a u8 lwp_area[128] should be fine.
> 

Sure, but any reason to *not* document the internal structure?

> 
>> +	struct bndregs_struct bndregs;
>> +	struct bndcsr_struct bndcsr;
>>  	/* new processor state extensions will go here */
>>  } __attribute__ ((packed, aligned (64)));
>>  
>> diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
>> index 0415cda..5cd9de3 100644
>> --- a/arch/x86/include/asm/xsave.h
>> +++ b/arch/x86/include/asm/xsave.h
>> @@ -9,6 +9,8 @@
>>  #define XSTATE_FP	0x1
>>  #define XSTATE_SSE	0x2
>>  #define XSTATE_YMM	0x4
>> +#define XSTATE_BNDREGS	0x8
>> +#define XSTATE_BNDCSR	0x10
>>  
>>  #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
>>  
>> @@ -20,10 +22,12 @@
>>  #define XSAVE_YMM_SIZE	    256
>>  #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
>>  
>> +#define XSTATE_FLEXIBLE (XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
> 
> What's the use of that macro if it is used only once?

Documentation seems good enough.  Explicitly separating out the features
which MUST be eagerly saved seems like a good thing.

>> +#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
>>  /*
>>   * These are the features that the OS can handle currently.
>>   */
>> -#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
>> +#define XCNTXT_MASK	(XSTATE_FLEXIBLE | XSTATE_EAGER)
>>  

	-hpa


