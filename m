Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaCUWEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:04:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47598 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbaCUWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:04:03 -0400
Date: Fri, 21 Mar 2014 18:04:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, fche@redhat.com,
        mingo@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH -tip v8 03/26] kprobes: Prohibit probing on .entry.text
 code
Message-ID: <20140321180400.0c1b2969@gandalf.local.home>
In-Reply-To: <20140305115904.22766.57607.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115904.22766.57607.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:04 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


>  struct kprobe_insn_cache {
>  	struct mutex mutex;
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index ceeadfc..5b5ac76 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -96,9 +96,6 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>  static struct kprobe_blackpoint kprobe_blacklist[] = {
>  	{"preempt_schedule",},
>  	{"native_get_debugreg",},
> -	{"irq_entries_start",},
> -	{"common_interrupt",},
> -	{"mcount",},	/* mcount can be called from everywhere */

Is mcount in the entry.text section? Also, what about ftrace_caller and
friends.

-- Steve
