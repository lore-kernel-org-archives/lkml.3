Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaCVAuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:50:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:35980 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751035AbaCVAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:50:34 -0400
Date: Fri, 21 Mar 2014 20:50:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v8 05/26] [BUGFIX] kprobes/x86: Prohibit probing on
 debug_stack_*
Message-ID: <20140321205032.722a588e@gandalf.local.home>
In-Reply-To: <20140305115918.22766.74108.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115918.22766.74108.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:18 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Prohibit probing on debug_stack_reset and debug_stack_set_zero.
> Since the both functions are called from TRACE_IRQS_ON/OFF_DEBUG
> macros which run in int3 ist entry, probing it may cause a soft
> lockup.
> 
> This happens when the kernel built with CONFIG_DYNAMIC_FTRACE=y
> and CONFIG_TRACE_IRQFLAGS=y.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
