Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3LTEWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:22:09 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40778 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3LTEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:22:06 -0500
Message-ID: <52B3C5E6.2040802@hitachi.com>
Date: Fri, 20 Dec 2013 13:21:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(), cleanup
 and fixes crash bugs
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <y0m38loefhx.fsf@fche.csb>
In-Reply-To: <y0m38loefhx.fsf@fche.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/20 5:46), Frank Ch. Eigler wrote:
> 
> Hi, Masami -
> 
> 
> masami.hiramatsu.pt wrote:
> 
>> Here is the version 6 of NOKPROBE_SYMBOL series. :)
>> [...]
> 
> Some preliminary results from building these on top of tip/master on
> x86-64.  
> 
> # stap -te "probe kprobe.function("*") {}"
> 
> starts up OK, without crashes, which looks like great progress.

That's a good news :)

>  But a
> closer look indicates that the insertion of kprobes is taking about
> three (!!) orders of magnitude longer than before, as judged by the
> rate of increase of 'wc -l /sys/kernel/debug/kprobes/list'.

Right, because kprobes are not designed for thousands of probes.

>  So, one
> has to let the thing run for several hours just to get all the kprobes
> inserted, never mind letting stress-testing begin.
> 
> For reference, here's the steady-state "perf top" output during all this
> insertion work:
> 
>  54.81%  [kernel]                    [k] _raw_spin_unlock_irqrestore
>  38.13%  [kernel]                    [k] __slab_alloc
>   1.11%  [kernel]                    [k] kprobe_ftrace_handler
>   0.88%  [kernel]                    [k] _raw_spin_unlock_irq

Hmm, interesting. Those probes are registered as disabled?
Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


