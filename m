Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3GVIVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:21:11 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:47219 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3GVIVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:21:08 -0400
Date: Mon, 22 Jul 2013 10:21:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: [PATCH -tip 3/3] x86: Remove unused text_poke_smp and
 text_poke_smp_batch
Message-ID: <20130722082104.GA26823@gmail.com>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
 <20130718114753.26675.18714.stgit@mhiramat-M0-7522>
 <20130722074339.GA25976@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722074339.GA25976@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > Since introducing the text_poke_bp for all text_poke_smp*
> > callers, text_poke_smp* are now unused. This basically
> > reverts 3d55cc8a, 7deb18dc and related commits.
> > 
> > This also fixes a Kconfig dependency issue on STOP_MACHINE
> > in the case of CONFIG_SMP && !CONFIG_MODULE_UNLOAD.
> > 
> > Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > ---
> >  arch/x86/Kconfig                   |    5 --
> >  arch/x86/include/asm/alternative.h |   11 ----
> >  arch/x86/kernel/alternative.c      |   98 +-----------------------------------
> >  3 files changed, 2 insertions(+), 112 deletions(-)
> 
> Hm, it does not build with the attached config:
> 
> arch/x86/kernel/kprobes/opt.c: In function 'setup_optimize_kprobe':
> arch/x86/kernel/kprobes/opt.c:394:6: error: dereferencing pointer to incomplete type
> arch/x86/kernel/kprobes/opt.c:395:6: error: dereferencing pointer to incomplete type
> arch/x86/kernel/kprobes/opt.c:396:6: error: dereferencing pointer to incomplete type

32-bit appears to be the key pattern.

Thanks,

	Ingo
