Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaCXUK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:10:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54263 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753879AbaCXUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:10:28 -0400
Date: Mon, 24 Mar 2014 16:10:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 16/26] ftrace/kprobes: Use NOKPROBE_SYMBOL macro
 in ftrace
Message-ID: <20140324161025.3f51bab6@gandalf.local.home>
In-Reply-To: <20140305120035.22766.90265.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305120035.22766.90265.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 21:00:35 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

  
> -static __kprobes
> +static
>  int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)

again, static and int should be on the same line.

>  {
>  	struct trace_kprobe *tk = container_of(ri->rp, struct trace_kprobe, rp);
> @@ -1268,6 +1279,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
>  #endif
>  	return 0;	/* We don't tweek kernel, so just return 0 */
>  }
> +NOKPROBE_SYMBOL(kretprobe_dispatcher);
>  
>  static struct trace_event_functions kretprobe_funcs = {
>  	.trace		= print_kretprobe_event

-- Steve
