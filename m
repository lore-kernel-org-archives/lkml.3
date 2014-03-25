Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaCYJUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:20:41 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55290 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaCYJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:20:35 -0400
Message-ID: <53314A5A.1000709@hitachi.com>
Date: Tue, 25 Mar 2014 18:20:26 +0900
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
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip v8 10/26] kprobes/x86: Allow probe on some kprobe
 preparation functions
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115953.22766.53497.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324153556.2ae6b181@gandalf.local.home>
In-Reply-To: <20140324153556.2ae6b181@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 4:35), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:59:53 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> There is no need to prohibit probing on the functions
>> used in preparation phase. Those are safely probed because
>> those are not invoked from breakpoint/fault/debug handlers,
>> there is no chance to cause recursive exceptions.
>>
>> Following functions are now removed from the kprobes blacklist.
>>  can_boost
>>  can_probe
>>  can_optimize
>>  is_IF_modifier
>>  __copy_instruction
>>  copy_optimized_instructions
>>  arch_copy_kprobe
>>  arch_prepare_kprobe
>>  arch_arm_kprobe
>>  arch_disarm_kprobe
>>  arch_remove_kprobe
> 
> Is there any possibility that the arm and disarm could cause issues if
> we have a probe in the middle of setting it?

No problem at least on x86, since we need to take a text_mutex for
arm/disarm, those must not be called from int3/debug interrupts.

> I guess not, but I just wanted to ask, as your test only tested the
> start of function and not the middle of it.

No I've not tested yet. OK, I'll test it and report.

Thank you,

> 
> -- Steve
> 
> 
>>  arch_trampoline_kprobe
>>  arch_prepare_kprobe_ftrace
>>  arch_prepare_optimized_kprobe
>>  arch_check_optimized_kprobe
>>  arch_within_optimized_kprobe
>>  __arch_remove_optimized_kprobe
>>  arch_remove_optimized_kprobe
>>  arch_optimize_kprobes
>>  arch_unoptimize_kprobe
>>
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


