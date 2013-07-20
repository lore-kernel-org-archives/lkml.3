Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3GTBgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 21:36:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3GTBgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 21:36:00 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_VFvyu300bgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=koCrvMhyhcMA:10 a=BXJWYrlj3RNJpKfsg1kA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374284157.3356.56.camel@gandalf.local.home>
Subject: Re: [PATCH -tip  0/3] kprobes, x86: Move optprobe on top of
 int3-based instruction patching
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>
Date: Fri, 19 Jul 2013 21:35:57 -0400
In-Reply-To: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 20:47 +0900, Masami Hiramatsu wrote:
> Hi,
> 
> Here is a series of kprobes and x86 patches for moving
> optprobe (jump optimized kprobe) onto the int3-based
> instruction patching (a.k.a. text_poke_bp, introduced by
> Jiri Kosina).
> 
> Since this completely moves text_poke_smp* user to new
> text_poke_bp, I also remove the old text_poke_smp* code
> from alternative.c. As a side effect, it also fixes a
> Kconfig warning about CONFIG_STOP_MACHINE dependency
> confliction.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (3):
>       [CLEANUP] kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
>       kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()
>       x86: Remove unused text_poke_smp and text_poke_smp_batch

Nice work Masami!

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> 
>  arch/x86/Kconfig                   |    5 --
>  arch/x86/include/asm/alternative.h |   11 ----
>  arch/x86/kernel/alternative.c      |   98 +-------------------------------
>  arch/x86/kernel/kprobes/common.h   |    5 --
>  arch/x86/kernel/kprobes/core.c     |    2 -
>  arch/x86/kernel/kprobes/opt.c      |  110 +++++++-----------------------------
>  6 files changed, 25 insertions(+), 206 deletions(-)
> 


