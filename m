Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaCYJW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:22:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47919 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaCYJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:22:58 -0400
Message-ID: <53314AEA.4040207@hitachi.com>
Date: Tue, 25 Mar 2014 18:22:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v8 11/26] kprobes: Allow probe on some kprobe functions
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120000.22766.77897.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324153701.18857126@gandalf.local.home>
In-Reply-To: <20140324153701.18857126@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 4:37), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 21:00:00 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> There is no need to prohibit probing on the functions
>> used for preparation, registeration, optimization,
>> controll etc. Those are safely probed because those are
>> not invoked from breakpoint/fault/debug handlers,
>> there is no chance to cause recursive exceptions.
>>
>> Following functions are now removed from the kprobes blacklist.
>> add_new_kprobe
>> aggr_kprobe_disabled
>> alloc_aggr_kprobe
>> alloc_aggr_kprobe
>> arm_all_kprobes
>> __arm_kprobe
>> arm_kprobe
>> arm_kprobe_ftrace
>> check_kprobe_address_safe
>> collect_garbage_slots
>> collect_garbage_slots
>> collect_one_slot
>> debugfs_kprobe_init
>> __disable_kprobe
>> disable_kprobe
>> disarm_all_kprobes
>> __disarm_kprobe
>> disarm_kprobe
>> disarm_kprobe_ftrace
>> do_free_cleaned_kprobes
>> do_optimize_kprobes
>> do_unoptimize_kprobes
>> enable_kprobe
>> force_unoptimize_kprobe
>> free_aggr_kprobe
>> free_aggr_kprobe
>> __free_insn_slot
>> __get_insn_slot
>> get_optimized_kprobe
>> __get_valid_kprobe
>> init_aggr_kprobe
>> init_aggr_kprobe
>> in_nokprobe_functions
>> kick_kprobe_optimizer
>> kill_kprobe
>> kill_optimized_kprobe
>> kprobe_addr
>> kprobe_optimizer
>> kprobe_queued
>> kprobe_seq_next
>> kprobe_seq_start
>> kprobe_seq_stop
>> kprobes_module_callback
>> kprobes_open
>> optimize_all_kprobes
>> optimize_kprobe
>> prepare_kprobe
>> prepare_optimized_kprobe
>> register_aggr_kprobe
>> register_jprobe
>> register_jprobes
>> register_kprobe
>> register_kprobes
>> register_kretprobe
>> register_kretprobe
>> register_kretprobes
>> register_kretprobes
>> report_probe
>> show_kprobe_addr
>> try_to_optimize_kprobe
>> unoptimize_all_kprobes
>> unoptimize_kprobe
>> unregister_jprobe
>> unregister_jprobes
>> unregister_kprobe
>> __unregister_kprobe_bottom
>> unregister_kprobes
>> __unregister_kprobe_top
>> unregister_kretprobe
>> unregister_kretprobe
>> unregister_kretprobes
>> unregister_kretprobes
>> wait_for_kprobe_optimizer
>>
> 
> Did you test these like you did with the previous patch? What about the
> middle of these functions?

No, not yet tested in middle of those functions. Only the entries are
tested. OK, I'll do that.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


