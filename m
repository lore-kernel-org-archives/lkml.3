Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaA0P0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:26:03 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:57845 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaA0P0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:26:01 -0500
Date: Mon, 27 Jan 2014 16:25:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Kees Cook <keescook@chromium.org>, crash-utility@redhat.com,
        linux-kernel@vger.kernel.org, Dave Anderson <anderson@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
Message-ID: <20140127152557.GA27792@gmail.com>
References: <20140123173120.GA25474@www.outflux.net>
 <20140125074738.GB10565@gmail.com>
 <52E669F1.9080603@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E669F1.9080603@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> On 25/01/14 09:47, Ingo Molnar wrote:
> > 
> > * Kees Cook <keescook@chromium.org> wrote:
> > 
> >> From: Eugene Surovegin <surovegin@google.com>
> >>
> >> Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.
> >>
> >> Signed-off-by: Eugene Surovegin <surovegin@google.com>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >> v2:
> >>  - make sure "From:" got sent correctly
> >> ---
> >>  arch/x86/kernel/machine_kexec_64.c |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> >> index 4eabc160696f..679cef0791cd 100644
> >> --- a/arch/x86/kernel/machine_kexec_64.c
> >> +++ b/arch/x86/kernel/machine_kexec_64.c
> >> @@ -279,5 +279,7 @@ void arch_crash_save_vmcoreinfo(void)
> >>  	VMCOREINFO_SYMBOL(node_data);
> >>  	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
> >>  #endif
> >> +	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
> >> +			      (unsigned long)&_text - __START_KERNEL);
> >>  }
> > 
> > I've Cc:-ed Adrian Hunter, who has sent the following kaslr fixes for 
> > perf yesterday:
> > 
> >   http://lkml.org/lkml/2014/1/24/220
> > 
> > Adrian, is this patch the right solution from the perf tooling 
> > perspective?
> 
> perf tools isn't a consumer of VMCOREINFO although I see VMCOREINFO 
> already has _stext which would be enough for many purposes.

Yes - but let me explain where I'm coming from: I'd like the recent 
KASLR related perf /proc/kcore based annotation bug to be fixed 
properly.

Currently I'm not sure about the status of it. In your fixes 
submission:

  Date: Fri, 24 Jan 2014 17:10:10 +0200
  From: Adrian Hunter <adrian.hunter@intel.com>
  Subject: [PATCH 0/8] perf tools: kaslr fixes

you mentioned the following:

    "- mustn't use kcore if the kernel has moved"

Does this that /proc/kcore annotation will not work if KASLR is 
active?

If yes then given that I expect most distros to turn on KASLR this 
would essentially make /proc/kcore useless on a large set of Linux 
systems. That would be suboptimal.

Thanks,

	Ingo
