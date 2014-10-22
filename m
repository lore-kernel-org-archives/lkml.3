Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbaJVL1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:27:22 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:31211 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932729AbaJVL1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:27:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,768,1406563200"; 
   d="scan'208";a="37725585"
Message-ID: <5447938C.5010304@cn.fujitsu.com>
Date: Wed, 22 Oct 2014 19:22:52 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuichi.kusakabe@jp.fujitsu.com" <yuichi.kusakabe@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] ARM: perf: armv7: wrap unsupported arch init functions
 via micro
References: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <1413966107-11881-2-git-send-email-chaiw.fnst@cn.fujitsu.com> <20141022110128.GE22642@leverpostej>
In-Reply-To: <20141022110128.GE22642@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 07:01 PM, Mark Rutland wrote:

> Hi,
> 
> On Wed, Oct 22, 2014 at 09:21:47AM +0100, chai wen wrote:
>> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
>> ---
>>  arch/arm/kernel/perf_event_v7.c |   52 +++++++++-----------------------------
>>  1 files changed, 13 insertions(+), 39 deletions(-)
> 
> I'm currently in the process of decoupling perf_event_{xscale,v6,v7}.c,
> which will result in the removal of these stubs and for the ARMv7,
> ARMv6, and XScale perf backends.
> 
> I haven't yet posted all the patches, but the basic idea is to make the
> arm_pmu code stateless and turn it into a library used by each of the
> three backends mentioned above. Each would have their own pmu_probe_info
> table (introduced in [1]), and would support the platform device IDs
> introduced in commit 253d8c3d2518ca6f (arm: perf: add more specific
> platform device IDs). The stubs would no longer be necessary.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/295822.html


Hi Mark

Got it.

Thanks for your information.
Your patches looks reasonable, I am OK with it.

thanks
chai wen

> 
> Thanks,
> Mark.
> 
>>
>> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
>> index f66a9b8..6c088e8 100644
>> --- a/arch/arm/kernel/perf_event_v7.c
>> +++ b/arch/arm/kernel/perf_event_v7.c
>> @@ -1459,43 +1459,17 @@ static int krait_pmu_init(struct arm_pmu *cpu_pmu)
>>  	return 0;
>>  }
>>  #else
>> -static inline int armv7_a8_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int armv7_a9_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int armv7_a5_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int armv7_a15_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int armv7_a12_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int armv7_a17_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> -
>> -static inline int krait_pmu_init(struct arm_pmu *cpu_pmu)
>> -{
>> -	return -ENODEV;
>> -}
>> +#define WRAP_UNSUPPORTED_INIT(__FUNC)                           \
>> +static inline int __FUNC(struct arm_pmu *cpu_pmu)               \
>> +{                                                               \
>> +        return -ENODEV;                                         \
>> +}
>> +WRAP_UNSUPPORTED_INIT(armv7_a8_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(armv7_a9_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(armv7_a5_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(armv7_a15_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(armv7_a7_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(armv7_a12_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(armv7_a17_pmu_init);
>> +WRAP_UNSUPPORTED_INIT(krait_pmu_init);
>>  #endif	/* CONFIG_CPU_V7 */
>> -- 
>> 1.7.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> .
> 



-- 
Regards

Chai Wen
