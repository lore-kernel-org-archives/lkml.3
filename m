Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKCJCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:02:08 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:49547 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbaKCJCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:02:05 -0500
Message-ID: <1415005321.20372.13.camel@x220>
Subject: Re: [GIT PULL] perf fixes
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <ak@linux.intel.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 03 Nov 2014 10:02:01 +0100
In-Reply-To: <20141031111332.GA26137@gmail.com>
References: <20141031111332.GA26137@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2014 09:02:01.0645 (UTC) FILETIME=[D4C375D0:01CFF744]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, 2014-10-31 at 12:13 +0100, Ingo Molnar wrote:
> Please pull the latest perf-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> 
>    # HEAD: d785452c9972fac2808479eb561d5c426b6e7d3b Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent
> 
>[...]
>
> Peter Zijlstra (2):
>       [...]
>       perf/x86: Fix compile warnings for intel_uncore

This was included in v3.18-rc3.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f2327e88e07c..ded8a6774ac9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -142,6 +142,10 @@ config INSTRUCTION_DECODER
>  	def_bool y
>  	depends on KPROBES || PERF_EVENTS || UPROBES
>  
> +config PERF_EVENTS_INTEL_UNCORE
> +	def_bool y
> +	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI

Andi spotted this typo (see https://lkml.org/lkml/2014/10/28/455 ). So
did my local perl script when it hit next-20141029. But since this was
already discussed I didn't bother to mention it too.

One expects this to be fixed by s/SUP_SUP_INTEL/CPU_SUP_INTEL/. Perhaps
the fix is more complicated, but anyhow, the typo isn't fixed in
next-20141103 or, as far as I can tell, in tip.git. So I decided to
remind you to make sure this doesn't fall through the cracks.

> +
>  config OUTPUT_FORMAT
>  	string
>  	default "elf32-i386" if X86_32


Paul Bolle

