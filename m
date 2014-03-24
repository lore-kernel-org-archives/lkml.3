Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaCXTgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:36:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:47987 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753623AbaCXTf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:35:58 -0400
Date: Mon, 24 Mar 2014 15:35:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip v8 10/26] kprobes/x86: Allow probe on some kprobe
 preparation functions
Message-ID: <20140324153556.2ae6b181@gandalf.local.home>
In-Reply-To: <20140305115953.22766.53497.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115953.22766.53497.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:53 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> There is no need to prohibit probing on the functions
> used in preparation phase. Those are safely probed because
> those are not invoked from breakpoint/fault/debug handlers,
> there is no chance to cause recursive exceptions.
> 
> Following functions are now removed from the kprobes blacklist.
>  can_boost
>  can_probe
>  can_optimize
>  is_IF_modifier
>  __copy_instruction
>  copy_optimized_instructions
>  arch_copy_kprobe
>  arch_prepare_kprobe
>  arch_arm_kprobe
>  arch_disarm_kprobe
>  arch_remove_kprobe

Is there any possibility that the arm and disarm could cause issues if
we have a probe in the middle of setting it?

I guess not, but I just wanted to ask, as your test only tested the
start of function and not the middle of it.

-- Steve


>  arch_trampoline_kprobe
>  arch_prepare_kprobe_ftrace
>  arch_prepare_optimized_kprobe
>  arch_check_optimized_kprobe
>  arch_within_optimized_kprobe
>  __arch_remove_optimized_kprobe
>  arch_remove_optimized_kprobe
>  arch_optimize_kprobes
>  arch_unoptimize_kprobe
> 

