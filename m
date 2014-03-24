Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaCXTij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:38:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48139 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754107AbaCXTih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:38:37 -0400
Date: Mon, 24 Mar 2014 15:38:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 12/26] ftrace/*probes: Allow probing on some
 functions
Message-ID: <20140324153830.72f17c4b@gandalf.local.home>
In-Reply-To: <20140305120007.22766.71082.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305120007.22766.71082.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 21:00:07 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1209,7 +1209,7 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
>   * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
>   * lockless, but we can't race with this __init function.
>   */
> -static __kprobes
> +static
>  int kprobe_register(struct ftrace_event_call *event,

Please keep the static on the same line as int. Either the above is one
line or:

static int
kprobe_register(...)

Like the rest of the patch does.

-- Steve

