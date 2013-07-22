Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3GVNxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:53:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3GVNxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:53:08 -0400
Date: Mon, 22 Jul 2013 15:53:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH -tip 3/3] x86: Remove unused text_poke_smp and
 text_poke_smp_batch
In-Reply-To: <20130722102148.GB1148@gmail.com>
Message-ID: <alpine.LNX.2.00.1307221545080.23128@pobox.suse.cz>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522> <20130718114753.26675.18714.stgit@mhiramat-M0-7522> <20130722074339.GA25976@gmail.com> <20130722082104.GA26823@gmail.com> <51ECEF8D.60109@hitachi.com> <20130722100158.GB908@gmail.com>
 <51ED053C.1070105@hitachi.com> <20130722102148.GB1148@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Ingo Molnar wrote:

> > >>>> Hm, it does not build with the attached config:
> > >>>>
> > >>>> arch/x86/kernel/kprobes/opt.c: In function 'setup_optimize_kprobe':
> > >>>> arch/x86/kernel/kprobes/opt.c:394:6: error: dereferencing pointer to incomplete type
> > >>>> arch/x86/kernel/kprobes/opt.c:395:6: error: dereferencing pointer to incomplete type
> > >>>> arch/x86/kernel/kprobes/opt.c:396:6: error: dereferencing pointer to incomplete type
> > >>>
> > >>> 32-bit appears to be the key pattern.
> > >>
> > >> Ingo, please make sure your x86/jumplabel tree picked all of my patches.
> > >> This 3/3 strongly depends on the previous 1/3 and 2/3.
> > >> Without it, kprobes/opt.c can not be build because it still uses the
> > >> text_poke_params data structure which 3/3 removes.
> > > 
> > > Yes I know, and it was on top of -tip which already had these included:
> > > 
> > >  51b2c07b2226 x86: Make jump_label use int3-based patching
> > >  fd4363fff3d9 x86: Introduce int3 (breakpoint)-based instruction patching
> > > 
> > > without these the third patch wouldn't even apply I think.
> > 
> > No, I meant below two patches:
> >  kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
> >  kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
> > 
> > Since the "setup_optimize_kprobe" in the error message is completely
> > *removed* by the second one, the above error should not happen.
> 
> Oh, indeed - I correctly applied them but then messed up the 
> cherry-picking, that's all.
> 
> So never mind, it's all fine.

Hi Ingo,

x86/jumplabel branch still seems to contain only Masami's "kprobes/x86: 
Remove unused text_poke_smp() and text_poke_smp_batch() functions", with 
the the prerequisity patches missing, which effectively means it's broken 
... are you planning to fix that up, please?

Thanks,

-- 
Jiri Kosina
SUSE Labs
