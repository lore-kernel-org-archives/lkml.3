Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaCXTqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:46:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:41186 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753833AbaCXThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:37:04 -0400
Date: Mon, 24 Mar 2014 15:37:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v8 11/26] kprobes: Allow probe on some kprobe
 functions
Message-ID: <20140324153701.18857126@gandalf.local.home>
In-Reply-To: <20140305120000.22766.77897.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305120000.22766.77897.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 21:00:00 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> There is no need to prohibit probing on the functions
> used for preparation, registeration, optimization,
> controll etc. Those are safely probed because those are
> not invoked from breakpoint/fault/debug handlers,
> there is no chance to cause recursive exceptions.
> 
> Following functions are now removed from the kprobes blacklist.
> add_new_kprobe
> aggr_kprobe_disabled
> alloc_aggr_kprobe
> alloc_aggr_kprobe
> arm_all_kprobes
> __arm_kprobe
> arm_kprobe
> arm_kprobe_ftrace
> check_kprobe_address_safe
> collect_garbage_slots
> collect_garbage_slots
> collect_one_slot
> debugfs_kprobe_init
> __disable_kprobe
> disable_kprobe
> disarm_all_kprobes
> __disarm_kprobe
> disarm_kprobe
> disarm_kprobe_ftrace
> do_free_cleaned_kprobes
> do_optimize_kprobes
> do_unoptimize_kprobes
> enable_kprobe
> force_unoptimize_kprobe
> free_aggr_kprobe
> free_aggr_kprobe
> __free_insn_slot
> __get_insn_slot
> get_optimized_kprobe
> __get_valid_kprobe
> init_aggr_kprobe
> init_aggr_kprobe
> in_nokprobe_functions
> kick_kprobe_optimizer
> kill_kprobe
> kill_optimized_kprobe
> kprobe_addr
> kprobe_optimizer
> kprobe_queued
> kprobe_seq_next
> kprobe_seq_start
> kprobe_seq_stop
> kprobes_module_callback
> kprobes_open
> optimize_all_kprobes
> optimize_kprobe
> prepare_kprobe
> prepare_optimized_kprobe
> register_aggr_kprobe
> register_jprobe
> register_jprobes
> register_kprobe
> register_kprobes
> register_kretprobe
> register_kretprobe
> register_kretprobes
> register_kretprobes
> report_probe
> show_kprobe_addr
> try_to_optimize_kprobe
> unoptimize_all_kprobes
> unoptimize_kprobe
> unregister_jprobe
> unregister_jprobes
> unregister_kprobe
> __unregister_kprobe_bottom
> unregister_kprobes
> __unregister_kprobe_top
> unregister_kretprobe
> unregister_kretprobe
> unregister_kretprobes
> unregister_kretprobes
> wait_for_kprobe_optimizer
> 

Did you test these like you did with the previous patch? What about the
middle of these functions?

-- Steve
