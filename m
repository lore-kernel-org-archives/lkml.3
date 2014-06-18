Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaFROof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:44:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40635 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaFROoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:44:34 -0400
Date: Wed, 18 Jun 2014 16:44:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
Message-ID: <20140618144429.GD24024@pd.tnic>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com>
 <20140618095739.GA24419@pd.tnic>
 <53A1A3A5.9010109@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A1A3A5.9010109@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 07:35:17AM -0700, Dave Hansen wrote:
> On 06/18/2014 02:57 AM, Borislav Petkov wrote:
> >> > @@ -339,6 +339,12 @@ extern const char * const x86_power_flags[32];
> >> >  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
> >> >  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
> >> >  
> >> > +#ifdef CONFIG_X86_INTEL_MPX
> >> > +#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
> > I think we don't want those macros anymore because they're obfuscating
> > the code. You should use static_cpu_has instead.
> 
> It looks like static_cpu_has() is the right thing to use instead of
> boot_cpu_has().  But, this doesn't just obfuscate things.
> 
> We actually _want_ the compiler to cull code out when the config option
> is off.  Things like do_bounds() will see code savings with _some_ kind
> of #ifdef rather than using static_cpu_has().

Why?

Practically, distros will have it enabled anyway (you have X86_INTEL_MPX
depend on CPU_SUP_INTEL).

Are you talking about the miniscule percentage of people building their
own kernels?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
