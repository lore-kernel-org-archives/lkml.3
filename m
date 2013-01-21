Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3AUH7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:59:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:45077 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3AUH7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:59:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="193332272"
Date: Mon, 21 Jan 2013 15:59:00 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] x86: Add cpu capability flag
 X86_FEATURE_TSC_S3_NOTSTOP
Message-ID: <20130121075900.GA509@feng-snb>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <1358750325-21217-2-git-send-email-feng.tang@intel.com>
 <20130121072729.GB11915@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121072729.GB11915@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:27:29AM -0500, Chen Gong wrote:
> On Mon, Jan 21, 2013 at 02:38:41PM +0800, Feng Tang wrote:
> > Date:	Mon, 21 Jan 2013 14:38:41 +0800
> > From: Feng Tang <feng.tang@intel.com>
> > To: Thomas Gleixner <tglx@linutronix.de>, John Stultz
> >  <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin"
> >  <hpa@linux.intel.com>, x86@kernel.org, Len Brown <lenb@kernel.org>,
> >  "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
> >  linux-kernel@vger.kernel.org
> > Cc: Feng Tang <feng.tang@intel.com>
> > Subject: [RFC PATCH 1/5] x86: Add cpu capability flag
> >  X86_FEATURE_TSC_S3_NOTSTOP
> > X-Mailer: git-send-email 1.7.9.5
> > 
> > On some new Intel Atom processors (Penwell and Cloverview), there is
> > a feature that the TSC won't stop S3, say the TSC value won't be
> > reset to 0 after resume. This feature makes TSC a more reliable
> > clocksource and could benefit the timekeeping code during system
> > suspend/resume cycle, so add a flag for it.
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  arch/x86/include/asm/cpufeature.h |    1 +
> >  arch/x86/kernel/cpu/intel.c       |   12 ++++++++++++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > index 2d9075e..f7e1eac 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -100,6 +100,7 @@
> >  #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
> >  #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
> >  #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
> > +#define X86_FEATURE_TSC_S3_NOTSTOP (3*32+30) /* TSC doesn't stop in S3 state */
> >  
> We have an existed "TSC always running in C3+" feature and name it as
> X86_FEATURE_NONSTOP_TSC, so how about naming it with the same style,
> like X86_FEATURE_NONSTOP_TSC_S3?

Yeah, actually I used a name X86_FEATURE_xxx_TSC, then I did a grep,
and found there is no unified name convention for TSC, so I chose such
a name.

--------------
#grep _TSC arch/x86/include/asm/cpufeature.h
#define X86_FEATURE_TSC         (0*32+ 4) /* Time Stamp Counter */
#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
#define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
#define X86_FEATURE_NONSTOP_TSC (3*32+24) /* TSC does not stop in C states */
#define X86_FEATURE_TSC_S3_NOTSTOP (3*32+30) /* TSC doesn't stop in S3 state */
#define X86_FEATURE_TSC_DEADLINE_TIMER  (4*32+24) /* Tsc deadline timer */
#define X86_FEATURE_TSCRATEMSR  (8*32+ 9) /* "tsc_scale" AMD TSC scaling support */
#define X86_FEATURE_TSC_ADJUST  (9*32+ 1) /* TSC adjustment MSR 0x3b */

Thanks,
Feng






