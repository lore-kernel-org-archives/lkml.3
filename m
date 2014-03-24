Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaCXS6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:58:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23477 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753552AbaCXS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:58:19 -0400
Date: Mon, 24 Mar 2014 14:58:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip v8 08/26] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
Message-ID: <20140324145815.1de836af@gandalf.local.home>
In-Reply-To: <532FF10A.8010502@hitachi.com>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115939.22766.21199.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140321210508.358c30ee@gandalf.local.home>
	<532FF10A.8010502@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 17:47:06 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> >> @@ -857,7 +857,7 @@ no_change:
> >>   * Interrupts are disabled on entry as trap1 is an interrupt gate and they
> >>   * remain disabled throughout this function.
> >>   */
> >> -static int __kprobes post_kprobe_handler(struct pt_regs *regs)
> >> +int __kprobes kprobe_debug_handler(struct pt_regs *regs)


> >> -		break;
> >> -	case DIE_DEBUG:
> >> -		if (post_kprobe_handler(args->regs)) {

> > 
> > The DIE_DEBUG case is removed but not added anyplace else. The change
> > log doesn't say why this was removed.
> 
> As you can see the above hunk, post_kprobe_handler() is now renamed
> as kprobe_debug_handler() which is called from do_debug() directly.
> 
> What I meant in the patch comment;
> 
> >> To avoid a kernel crash by probing on lockdep code, call
> >> kprobe_int3_handler and kprobe_debug_handler directly
> >> from do_int3 and do_debug.
> 
> was actually pointing that change...
> 


I missed the rename of post_kprobe_handler().

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
