Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3KAN5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:57:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:51287 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753801Ab3KAN45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:56:57 -0400
Date: Fri, 1 Nov 2013 09:56:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -tip v2 2/3] [BUGFIX] kprobes/x86: Prohibit probing on
 debug_stack_*
Message-ID: <20131101095654.37db1b24@gandalf.local.home>
In-Reply-To: <20131101112534.14657.22729.stgit@kbuild-fedora.novalocal>
References: <20131101112530.14657.87835.stgit@kbuild-fedora.novalocal>
	<20131101112534.14657.22729.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 11:25:34 +0000
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
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
