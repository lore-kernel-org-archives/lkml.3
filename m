Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3GVKVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:21:53 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33404 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3GVKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:21:52 -0400
Date: Mon, 22 Jul 2013 12:21:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH -tip 3/3] x86: Remove unused text_poke_smp and
 text_poke_smp_batch
Message-ID: <20130722102148.GB1148@gmail.com>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
 <20130718114753.26675.18714.stgit@mhiramat-M0-7522>
 <20130722074339.GA25976@gmail.com>
 <20130722082104.GA26823@gmail.com>
 <51ECEF8D.60109@hitachi.com>
 <20130722100158.GB908@gmail.com>
 <51ED053C.1070105@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED053C.1070105@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/07/22 19:01), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >> (2013/07/22 17:21), Ingo Molnar wrote:
> >>>
> >>> * Ingo Molnar <mingo@kernel.org> wrote:
> >>>
> >>>>
> >>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> >>>>
> >>>>> Since introducing the text_poke_bp for all text_poke_smp*
> >>>>> callers, text_poke_smp* are now unused. This basically
> >>>>> reverts 3d55cc8a, 7deb18dc and related commits.
> >>>>>
> >>>>> This also fixes a Kconfig dependency issue on STOP_MACHINE
> >>>>> in the case of CONFIG_SMP && !CONFIG_MODULE_UNLOAD.
> >>>>>
> >>>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >>>>> ---
> >>>>>  arch/x86/Kconfig                   |    5 --
> >>>>>  arch/x86/include/asm/alternative.h |   11 ----
> >>>>>  arch/x86/kernel/alternative.c      |   98 +-----------------------------------
> >>>>>  3 files changed, 2 insertions(+), 112 deletions(-)
> >>>>
> >>>> Hm, it does not build with the attached config:
> >>>>
> >>>> arch/x86/kernel/kprobes/opt.c: In function 'setup_optimize_kprobe':
> >>>> arch/x86/kernel/kprobes/opt.c:394:6: error: dereferencing pointer to incomplete type
> >>>> arch/x86/kernel/kprobes/opt.c:395:6: error: dereferencing pointer to incomplete type
> >>>> arch/x86/kernel/kprobes/opt.c:396:6: error: dereferencing pointer to incomplete type
> >>>
> >>> 32-bit appears to be the key pattern.
> >>
> >> Ingo, please make sure your x86/jumplabel tree picked all of my patches.
> >> This 3/3 strongly depends on the previous 1/3 and 2/3.
> >> Without it, kprobes/opt.c can not be build because it still uses the
> >> text_poke_params data structure which 3/3 removes.
> > 
> > Yes I know, and it was on top of -tip which already had these included:
> > 
> >  51b2c07b2226 x86: Make jump_label use int3-based patching
> >  fd4363fff3d9 x86: Introduce int3 (breakpoint)-based instruction patching
> > 
> > without these the third patch wouldn't even apply I think.
> 
> No, I meant below two patches:
>  kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
>  kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
> 
> Since the "setup_optimize_kprobe" in the error message is completely
> *removed* by the second one, the above error should not happen.

Oh, indeed - I correctly applied them but then messed up the 
cherry-picking, that's all.

So never mind, it's all fine.

Thanks,

	Ingo
