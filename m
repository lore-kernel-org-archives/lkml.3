Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaCXUMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:12:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:63093 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877AbaCXUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:12:29 -0400
Date: Mon, 24 Mar 2014 16:12:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v8 17/26] notifier: Use NOKPROBE_SYMBOL macro in
 notifier
Message-ID: <20140324161227.6b93b5af@gandalf.local.home>
In-Reply-To: <20140305120042.22766.48538.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305120042.22766.48538.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 21:00:42 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Use NOKPROBE_SYMBOL macro to protect functions from
> kprobes instead of __kprobes annotation in notifier.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

>  /*
>   *	Blocking notifier chain routines.  All access to the chain is
> @@ -527,7 +530,7 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
>  
>  static ATOMIC_NOTIFIER_HEAD(die_chain);
>  
> -int notrace __kprobes notify_die(enum die_val val, const char *str,
> +int notrace notify_die(enum die_val val, const char *str,

Hmm, I wonder why notify_die() is marked notrace? But that's unrelated
to this patch.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  	       struct pt_regs *regs, long err, int trap, int sig)
>  {
>  	struct die_args args = {
> @@ -540,6 +543,7 @@ int notrace __kprobes notify_die(enum die_val val, const char *str,
>  	};
>  	return atomic_notifier_call_chain(&die_chain, val, &args);
>  }
> +NOKPROBE_SYMBOL(notify_die);
>  
>  int register_die_notifier(struct notifier_block *nb)
>  {
> 

