Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3GWILe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:11:34 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58744 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3GWIKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:50 -0400
Date: Tue, 23 Jul 2013 10:10:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH -tip 3/3] x86: Remove unused text_poke_smp and
 text_poke_smp_batch
Message-ID: <20130723081046.GA16088@gmail.com>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
 <20130718114753.26675.18714.stgit@mhiramat-M0-7522>
 <20130722074339.GA25976@gmail.com>
 <20130722082104.GA26823@gmail.com>
 <51ECEF8D.60109@hitachi.com>
 <20130722100158.GB908@gmail.com>
 <51ED053C.1070105@hitachi.com>
 <20130722102148.GB1148@gmail.com>
 <alpine.LNX.2.00.1307221545080.23128@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307221545080.23128@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 22 Jul 2013, Ingo Molnar wrote:
> 
> > > >>>> Hm, it does not build with the attached config:
> > > >>>>
> > > >>>> arch/x86/kernel/kprobes/opt.c: In function 'setup_optimize_kprobe':
> > > >>>> arch/x86/kernel/kprobes/opt.c:394:6: error: dereferencing pointer to incomplete type
> > > >>>> arch/x86/kernel/kprobes/opt.c:395:6: error: dereferencing pointer to incomplete type
> > > >>>> arch/x86/kernel/kprobes/opt.c:396:6: error: dereferencing pointer to incomplete type
> > > >>>
> > > >>> 32-bit appears to be the key pattern.
> > > >>
> > > >> Ingo, please make sure your x86/jumplabel tree picked all of my patches.
> > > >> This 3/3 strongly depends on the previous 1/3 and 2/3.
> > > >> Without it, kprobes/opt.c can not be build because it still uses the
> > > >> text_poke_params data structure which 3/3 removes.
> > > > 
> > > > Yes I know, and it was on top of -tip which already had these included:
> > > > 
> > > >  51b2c07b2226 x86: Make jump_label use int3-based patching
> > > >  fd4363fff3d9 x86: Introduce int3 (breakpoint)-based instruction patching
> > > > 
> > > > without these the third patch wouldn't even apply I think.
> > > 
> > > No, I meant below two patches:
> > >  kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
> > >  kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
> > > 
> > > Since the "setup_optimize_kprobe" in the error message is completely
> > > *removed* by the second one, the above error should not happen.
> > 
> > Oh, indeed - I correctly applied them but then messed up the 
> > cherry-picking, that's all.
> > 
> > So never mind, it's all fine.
> 
> Hi Ingo,
> 
> x86/jumplabel branch still seems to contain only Masami's "kprobes/x86: 
> Remove unused text_poke_smp() and text_poke_smp_batch() functions", with 
> the the prerequisity patches missing, which effectively means it's 
> broken ... are you planning to fix that up, please?

That must be a Git server push-out delay - it should contain two patches:

 51b2c07b2226 x86: Make jump_label use int3-based patching
 fd4363fff3d9 x86: Introduce int3 (breakpoint)-based instruction patching

The kprobes patches are in perf/core, with x86/jumplabel merged in:

 ea8596bb2d8d kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions
 a7b0133ea94e kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
 c7e85c42be68 kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
 9bb15425c3bc Merge branch 'x86/jumplabel' into perf/core

Thanks,

	Ingo
