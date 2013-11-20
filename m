Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3KTR4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:56:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58884 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754686Ab3KTR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:56:53 -0500
Date: Wed, 20 Nov 2013 12:56:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v3 00/23] kprobes: introduce NOKPROBE_SYMBOL() and
 general cleaning of kprobe blacklist
Message-ID: <20131120125649.40ca99c3@gandalf.local.home>
In-Reply-To: <20131120173600.GK8993@redhat.com>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
	<y0mvbznxi6k.fsf@fche.csb>
	<20131120153801.GA9743@gmail.com>
	<20131120173600.GK8993@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 12:36:00 -0500
"Frank Ch. Eigler" <fche@redhat.com> wrote:

> Hi -
> 
> > > Does this new blacklist cover enough that the kernel now survives a 
> > > broadly wildcarded perf-probe, e.g. over e.g. all of its kallsyms?
> > 
> > That's generally the purpose of the annotations - if it doesn't then 
> > that's a bug.
> 
> AFAIK, no kernel since kprobes was introduced has ever stood up to
> that test.  perf probe lacks the wildcarding powers of systemtap, so
> one needs to resort to something like:
> 
> # cat /proc/kallsyms | grep ' [tT] ' | while read addr type symbol; do
>    perf probe $symbol
> done

I'm curious to why one would do that. IIUC, perf now has function
tracing support.

-- Steve

> 
> then wait for a few hours for that to finish. Then, or while the loop
> is still running, run
> 
> # perf record -e 'probe:*' -aR sleep 1
> 
> to take a kernel down.
> 
> 
> - FChE

