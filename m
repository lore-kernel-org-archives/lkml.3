Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3LFP7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:59:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58017 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab3LFP7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:59:13 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131206133339.GC6694@pd.tnic>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com> <1386355976-11732-2-git-send-email-qiaowei.ren@intel.com> <20131206133339.GC6694@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/3] X86, mpx: Intel MPX definition
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 06 Dec 2013 07:58:17 -0800
To: Borislav Petkov <bp@alien8.de>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Message-ID: <7762f6ad-fb19-4621-9105-8c3e68c367f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No... we always ask for cpufeature.h patches separately because they sometimes cause conflicts between branches.

Borislav Petkov <bp@alien8.de> wrote:
>On Sat, Dec 07, 2013 at 02:52:55AM +0800, Qiaowei Ren wrote:
>> 
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
>> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
>> ---
>>  arch/x86/include/asm/cpufeature.h |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>
>This patch should probably be merged with the next one...
>
>> 
>> diff --git a/arch/x86/include/asm/cpufeature.h
>b/arch/x86/include/asm/cpufeature.h
>> index d3f5c63..6c2738d 100644
>> --- a/arch/x86/include/asm/cpufeature.h
>> +++ b/arch/x86/include/asm/cpufeature.h
>> @@ -216,6 +216,7 @@
>>  #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
>>  #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor
>Context ID */
>>  #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional
>Memory */
>> +#define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
>>  #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
>>  #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions
>*/
>>  #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access
>Prevention */
>> @@ -330,6 +331,7 @@ extern const char * const x86_power_flags[32];
>>  #define cpu_has_perfctr_l2	boot_cpu_has(X86_FEATURE_PERFCTR_L2)
>>  #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
>>  #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
>> +#define cpu_has_mpx		boot_cpu_has(X86_FEATURE_MPX)
>
>... and we're trying to not have more of those macros so people should
>be simply
>using boot_cpu_has(X86_FEATURE_YYY).

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
