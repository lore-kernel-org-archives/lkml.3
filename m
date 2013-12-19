Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3LSUqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:46:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab3LSUqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:46:21 -0500
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(), cleanup and fixes crash bugs
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 19 Dec 2013 15:46:02 -0500
In-Reply-To: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> (Masami Hiramatsu's message of "Thu, 19 Dec 2013 09:03:54 +0000")
Message-ID: <y0m38loefhx.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Masami -


masami.hiramatsu.pt wrote:

> Here is the version 6 of NOKPROBE_SYMBOL series. :)
> [...]

Some preliminary results from building these on top of tip/master on
x86-64.  

# stap -te "probe kprobe.function("*") {}"

starts up OK, without crashes, which looks like great progress.  But a
closer look indicates that the insertion of kprobes is taking about
three (!!) orders of magnitude longer than before, as judged by the
rate of increase of 'wc -l /sys/kernel/debug/kprobes/list'.  So, one
has to let the thing run for several hours just to get all the kprobes
inserted, never mind letting stress-testing begin.

For reference, here's the steady-state "perf top" output during all this
insertion work:

 54.81%  [kernel]                    [k] _raw_spin_unlock_irqrestore
 38.13%  [kernel]                    [k] __slab_alloc
  1.11%  [kernel]                    [k] kprobe_ftrace_handler
  0.88%  [kernel]                    [k] _raw_spin_unlock_irq

More notes once the machine gets far enough to get to the robustness
testing phase.

- FChE
