Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3DSHZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:25:07 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46445 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab3DSHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:25:05 -0400
Date: Fri, 19 Apr 2013 09:25:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Fix a double lock bug of
 kprobe_mutex
Message-ID: <20130419072500.GA21866@gmail.com>
References: <20130418093318.13070.29847.stgit@mhiramat-M0-7522>
 <20130418181709.GE9897@mtj.dyndns.org>
 <20130419072250.GA20897@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130419072250.GA20897@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > On Thu, Apr 18, 2013 at 06:33:18PM +0900, Masami Hiramatsu wrote:
> > > Fix a double locking bug caused when debug.kprobe-optimization=0.
> > > While the proc_kprobes_optimization_handler locks kprobe_mutex,
> > > wait_for_kprobe_optimizer locks it again and that causes a double lock.
> > > To fix the bug, this introduces different mutex for protecting
> > > sysctl parameter and locks it in proc_kprobes_optimization_handler.
> > > Of course, since we need to lock kprobe_mutex when touching kprobes
> > > resources, that is done in *optimize_all_kprobes().
> > > 
> > > This bug was from ad72b3bea744b4db01c89af0f86f3e8920d354df
> > > 
> > > Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > 
> > Oops,
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Since you pushed the original commit, mind pushing this fix to Linus too?

I see Linus applied it out of email, so never mind.

Thanks,

	Ingo
