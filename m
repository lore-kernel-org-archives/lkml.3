Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaBVUtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 15:49:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaBVUtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 15:49:50 -0500
Date: Sat, 22 Feb 2014 21:49:36 +0100
From: Borislav Petkov <bp@suse.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Feng Tang <feng.tang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>, Jan Beulich <JBeulich@suse.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Landley <rob@landley.net>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: Support compiling out human-friendly
 processor feature names
Message-ID: <20140222204936.GA2534@pd.tnic>
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org>
 <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 11:57:10AM -0800, Josh Triplett wrote:

...

> diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
> index 6ec6bb6..29207f6 100644
> --- a/arch/x86/boot/cpu.c
> +++ b/arch/x86/boot/cpu.c
> @@ -16,7 +16,9 @@
>   */
>  
>  #include "boot.h"
> +#ifdef CONFIG_X86_FEATURE_NAMES
>  #include "cpustr.h"
> +#endif

You probably could get rid of this ifdef too by moving it into cpustr.h
after teaching arch/x86/boot/mkcpustr.c to issue it...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
