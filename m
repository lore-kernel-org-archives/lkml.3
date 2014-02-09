Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaBIOhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:37:15 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63326 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:37:12 -0500
Date: Sun, 9 Feb 2014 15:37:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(),
 cleanup and fixes crash bugs
Message-ID: <20140209143709.GA31608@gmail.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
 <y0m38loefhx.fsf@fche.csb>
 <52B3C5E6.2040802@hitachi.com>
 <20131220082056.GA15934@gmail.com>
 <52B40E79.8040701@hitachi.com>
 <20131220104615.GA22609@gmail.com>
 <52E8E487.2090007@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E8E487.2090007@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> I guess the second reason is why the stap takes so long time to set 
> probes. stap tries to register kprobes without disabled flag, that 
> means we enables thousands of probes (overheads).
> 
> So the similar thing happens when we enables events as below;
> 
>   # for i in /sys/kernel/debug/tracing/events/kprobes/* ; do date; echo 1 > $i; done
>   Wed Jan 29 10:44:50 UTC 2014
>   ...
> 
> I tried it and canceled after 4 min passed. It enabled about 17k 
> events and slowed down my system very much(I almost got hang check 
> timer).

Ok, I guess that's the slowdown bug that Frank reported.

> I think we should have some performance statistics (hit count?) and 
> if it goes over a threshold, we should stop enabling other events.

That really feels like a hack. How about fixing the root cause? Does 
the enabling of all probes have to be so slow?

Thanks,

	Ingo
