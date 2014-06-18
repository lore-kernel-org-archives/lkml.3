Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaFRO6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:58:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:58856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaFRO6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="559599404"
Message-ID: <53A1A90D.5010604@intel.com>
Date: Wed, 18 Jun 2014 07:58:21 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <20140618144429.GD24024@pd.tnic>
In-Reply-To: <20140618144429.GD24024@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 07:44 AM, Borislav Petkov wrote:
> On Wed, Jun 18, 2014 at 07:35:17AM -0700, Dave Hansen wrote:
>> On 06/18/2014 02:57 AM, Borislav Petkov wrote:
>>>>> @@ -339,6 +339,12 @@ extern const char * const x86_power_flags[32];
>>>>>  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>>>>>  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
>>>>>  
>>>>> +#ifdef CONFIG_X86_INTEL_MPX
>>>>> +#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
>>> I think we don't want those macros anymore because they're obfuscating
>>> the code. You should use static_cpu_has instead.
>>
>> It looks like static_cpu_has() is the right thing to use instead of
>> boot_cpu_has().  But, this doesn't just obfuscate things.
>>
>> We actually _want_ the compiler to cull code out when the config option
>> is off.  Things like do_bounds() will see code savings with _some_ kind
>> of #ifdef rather than using static_cpu_has().
> 
> Why?

Are you seriously asking why we would want to cull out code guaranteed
to be unused?

People are going to want to turn this off at compile time.  When they
do, I want as much of the code to go away as is reasonably possible.
Adding a single-line #ifdef in a header qualifies as a pretty decent
tradeoff in my book.

I'm sure Qiaowei will do an experiment and show us what the code savings
are.

> Practically, distros will have it enabled anyway (you have X86_INTEL_MPX
> depend on CPU_SUP_INTEL).
> 
> Are you talking about the miniscule percentage of people building their
> own kernels?

The minuscule number of people not using a distro kernel?  Like, every
Android and Chrome device in the world?  How about the cloud providers
with millions of servers?

