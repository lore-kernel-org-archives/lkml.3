Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaCaHRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:17:54 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50330 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaCaHRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:17:53 -0400
Date: Mon, 31 Mar 2014 09:17:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140331071749.GA1252@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> Hi All,
> 
> The following set of patches add ktap tracing tool. 
> 
> ktap is a new script-based dynamic tracing tool for Linux.
> It uses a scripting language and lets the user trace system dynamically.
> 
> Highlights features:
> * a simple but powerful scripting language
> * register-based interpreter (heavily optimized) in Linux kernel
> * small and lightweight
> * not depend on the GCC toolchain for each script run
> * easy to use in embedded environments without debugging info
> * support for tracepoint, kprobe, uprobe, function trace, timer, and more
> * supported in x86, ARM, PowerPC, MIPS
> * safety in sandbox

I've asked this fundamental design question before but got no full 
answer: how does ktap compare to the ongoing effort of improving the 
BPF scripting engine?

There's several efforts here that I'm aware of:

 1) 64-bit BPF, integration with ftrace scripting, see this lkml 
    thread:

    [RFC PATCH v2 tip 0/7] 64-bit BPF insn set and tracing filters

 2) better BPF integration with networking:

    [PATCH net-next v3 8/9] net: filter: rework/optimize internal BPF interpreter's instruction set

Your patches introduce a separate bytecode interpreter in 
kernel/trace/ktap/ and that's overlapping with BPF.

>From a long term instrumentation code maintenance point of view the 
last thing we want is several overlapping scripting engines.

Thanks,

	Ingo
