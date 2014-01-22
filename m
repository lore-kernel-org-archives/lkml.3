Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaAVVdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:33:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:46969 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaAVVda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:33:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,702,1384329600"; 
   d="scan'208";a="335985428"
Date: Wed, 22 Jan 2014 13:38:40 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: randconfig build error with next-20140122, in
 arch/x86/platform/intel-mid/intel-mid.c
Message-ID: <20140122213839.GA26480@psi-dev26.jf.intel.com>
References: <CA+r1ZhgAbZH19kbVfKgeVJ0tPqGpJ86b10GAYaGVgDn2Q58Dyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhgAbZH19kbVfKgeVJ0tPqGpJ86b10GAYaGVgDn2Q58Dyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 22, 2014 at 11:45:42AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> In file included from arch/x86/platform/intel-mid/intel-mid.c:38:0:
> arch/x86/platform/intel-mid/intel_mid_weak_decls.h:17:25: error:
> expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
> ‘get_penwell_ops’
>  extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
>                          ^
> arch/x86/platform/intel-mid/intel_mid_weak_decls.h:18:25: error:
> expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
> ‘get_cloverview_ops’
>  extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
>                          ^
> In file included from arch/x86/platform/intel-mid/intel-mid.c:30:0:
> /home/jim/linux/arch/x86/include/asm/intel-mid.h:74:15: error:
> ‘get_penwell_ops’ undeclared here (not in a function)
>      [cpuid] = get_##cpuname##_ops
>                ^
> /home/jim/linux/arch/x86/include/asm/intel-mid.h:84:2: note: in
> expansion of macro ‘DECLARE_INTEL_MID_OPS_INIT’
>   DECLARE_INTEL_MID_OPS_INIT(penwell, INTEL_MID_CPU_CHIP_PENWELL), \
>   ^
> arch/x86/platform/intel-mid/intel-mid.c:66:45: note: in expansion of
> macro ‘INTEL_MID_OPS_INIT’
>  static void *(*get_intel_mid_ops[])(void) = INTEL_MID_OPS_INIT;
>                                              ^
> /home/jim/linux/arch/x86/include/asm/intel-mid.h:74:15: error:
> ‘get_cloverview_ops’ undeclared here (not in a function)
>      [cpuid] = get_##cpuname##_ops
>                ^
> /home/jim/linux/arch/x86/include/asm/intel-mid.h:85:2: note: in
> expansion of macro ‘DECLARE_INTEL_MID_OPS_INIT’
>   DECLARE_INTEL_MID_OPS_INIT(cloverview, INTEL_MID_CPU_CHIP_CLOVERVIEW), \
>   ^
> arch/x86/platform/intel-mid/intel-mid.c:66:45: note: in expansion of
> macro ‘INTEL_MID_OPS_INIT’
>  static void *(*get_intel_mid_ops[])(void) = INTEL_MID_OPS_INIT;
>                                              ^
> make[3]: *** [arch/x86/platform/intel-mid/intel-mid.o] Error 1

I just acked a patch fixing this problem. Please, consider apply this as
fix:
https://lkml.org/lkml/2014/1/22/327

Br, David Cohen
