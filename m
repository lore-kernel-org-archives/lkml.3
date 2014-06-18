Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaFROf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:35:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:61960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaFROf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="559589477"
Message-ID: <53A1A3A5.9010109@intel.com>
Date: Wed, 18 Jun 2014 07:35:17 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic>
In-Reply-To: <20140618095739.GA24419@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:57 AM, Borislav Petkov wrote:
>> > @@ -339,6 +339,12 @@ extern const char * const x86_power_flags[32];
>> >  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>> >  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
>> >  
>> > +#ifdef CONFIG_X86_INTEL_MPX
>> > +#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
> I think we don't want those macros anymore because they're obfuscating
> the code. You should use static_cpu_has instead.

It looks like static_cpu_has() is the right thing to use instead of
boot_cpu_has().  But, this doesn't just obfuscate things.

We actually _want_ the compiler to cull code out when the config option
is off.  Things like do_bounds() will see code savings with _some_ kind
of #ifdef rather than using static_cpu_has().

So, we can either use the well worn, consistent with other features in
x86, cpu_has_$foo approach.  Or, we can roll our own macros.
