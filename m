Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaEIDoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:44:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29758 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752269AbaEIDoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:44:01 -0400
Date: Thu, 8 May 2014 23:43:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v10 7/7] ftrace: Introduce
 FTRACE_OPS_FL_SELF_FILTER for ftrace-kprobe
Message-ID: <20140508234355.38ac66ee@gandalf.local.home>
In-Reply-To: <536C4761.9050609@hitachi.com>
References: <20140508093842.31767.43766.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140508093930.31767.86419.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140508065947.214f4951@gandalf.local.home>
	<536C4761.9050609@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2014 12:11:29 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > Hmm, I wonder if I should add the check for:
> > 
> > 	!(op->flags & FTRACE_OPS_FL_STUB)
> > 
> > here too? But that's another change that I'll do.
> 
> Indeed. BTW, should I change ftrace_ops_control_func() too?
> 

Currently there's no users of it, so I guess it could wait. Otherwise
we are adding a check that will never be true in an extreme hot path.

-- Steve

