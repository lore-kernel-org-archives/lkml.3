Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326Ab3LIRFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:05:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26878 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761279Ab3LIREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:04:53 -0500
Date: Mon, 9 Dec 2013 12:04:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v5 12/18] ftrace/kprobes: Use NOKPROBE_SYMBOL macro
 in ftrace
Message-ID: <20131209120450.4da43296@gandalf.local.home>
In-Reply-To: <20131209104746.13397.22146.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
	<20131209104746.13397.22146.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Dec 2013 10:47:46 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -124,8 +124,8 @@ struct probe_arg {
>  	const struct fetch_type	*type;	/* Type of this argument */
>  };
>  
> -static inline __kprobes void call_fetch(struct fetch_param *fprm,
> -				 struct pt_regs *regs, void *dest)
> +static inline void call_fetch(struct fetch_param *fprm,
> +			      struct pt_regs *regs, void *dest)
>  {
>  	return fprm->fn(regs, fprm->data, dest);
>  }
> 

Is this OK to be probed? I've had cases where a header "static inline"
was not always inlined. Unless you have "__always_inline" this is not
guaranteed to be inlined.

As for the rest of the patch:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

