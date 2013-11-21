Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3KUH3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 02:29:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44662 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3KUH3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 02:29:42 -0500
Date: Thu, 21 Nov 2013 08:29:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v3 00/23] kprobes: introduce NOKPROBE_SYMBOL() and
 general cleaning of kprobe blacklist
Message-ID: <20131121072938.GA16912@gmail.com>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
 <y0mvbznxi6k.fsf@fche.csb>
 <20131120153801.GA9743@gmail.com>
 <20131120173600.GK8993@redhat.com>
 <528D6C9F.8050809@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528D6C9F.8050809@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/11/21 2:36), Frank Ch. Eigler wrote:

[ ... ]
> > one needs to resort to something like:
> > 
> > # cat /proc/kallsyms | grep ' [tT] ' | while read addr type symbol; do
> >    perf probe $symbol
> > done
> > 
> > then wait for a few hours for that to finish. Then, or while the loop
> > is still running, run
> > 
> > # perf record -e 'probe:*' -aR sleep 1
> > 
> > to take a kernel down.
> 
> Um, indeed, current blacklist is not perfect. [...]

Then it needs to be fixed ASAP!

> [...] As I reported in this series, I've found 2 more patterns. I 
> guess there still have some others.
> 
> But anyway, I don't think it is good to fix all such bugs in this 
> series.

Fixing these bugs is far more important than any cleanup work.

We can apply the fixes together with your cleanup series to make it 
all simpler, but the bug fixing absolutely needs to happen right now.

Thanks,

	Ingo
