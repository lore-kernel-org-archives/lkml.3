Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3LEOta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:49:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab3LEOtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:49:24 -0500
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
	<20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 05 Dec 2013 09:49:04 -0500
In-Reply-To: <529FBA71.6070107@hitachi.com> (Masami Hiramatsu's message of "Thu, 05 Dec 2013 08:27:45 +0900")
Message-ID: <y0mvbz3pd3z.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Masami -

masami.hiramatsu.pt wrote:

> [...]
> For the safeness of kprobes, I have an idea; introduce a whitelist
> for dynamic events. AFAICS, the biggest unstable issue of kprobes
> comes from putting *many* probes on the functions called from tracers.

Why do you think so?  We have had problems with single kprobes in the
"wrong" spot.  The main reason I showed spraying them widely is to get
wide coverage with minimal information/effort, not to suggest that the
number of concurrent probes per se is a problem.  (We have had
systemtap scripts probing some areas of the kernel with thousands of
active kprobes, e.g. for statement-by-statement variable-watching
jobs, and these have worked fine.)


> It doesn't crash the kernel but slows down so much, because every
> probes hit many other nested miss-hit probes. 

(kprobes does have code to detect & handle reentrancy.)

> This gives us a big performance impact. [...]

Sure, but I'd expect to see pure slowdowns show their impact with
time-related problems like watchdogs firing or timeouts.


> [...]  Then, I'd like to propose this new whitelist feature in
> kprobe-tracer (not raw kprobe itself). And a sysctl knob for
> disabling the whitelist.  That knob will be
> /proc/sys/debug/kprobe-event-whitelist and disabling it will mark
> kernel tainted so that we can check it from bug reports.

How would one assemble a reliable whitelist, if we haven't fully
characterized the problems that make the blacklist necessary?


- FChE
