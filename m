Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaHMUMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:12:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:50473 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHMUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:12:14 -0400
Date: Wed, 13 Aug 2014 17:12:10 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf ui/tui: Fix a small callchain display bug
Message-ID: <20140813201210.GH2718@kernel.org>
References: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
 <20140813081909.GA6399@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813081909.GA6399@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 10:19:09AM +0200, Ingo Molnar escreveu:
> * Namhyung Kim <namhyung@kernel.org> wrote:
> > Before:

> >   Children      Self  Command  Shared Object      Symbols
> > ---------------------------------------------------------------------------
> > -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
> >    + cpuidle_wrap_enter
> >    + cpuidle_enter_tk
> >    + cpuidle_idle_call
> >    + cpu_idle

> > After:

> >   Children      Self  Command  Shared Object      Symbols
> > ---------------------------------------------------------------------------
> > -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
> >      cpuidle_wrap_enter
> >      cpuidle_enter_tk
> >      cpuidle_idle_call
> >    + cpu_idle
> > 
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> 
> Nice fix!

Indeed, longstanding problem, kudos to Namhyung for deving into TUI +
callchain land to fix this!

- Arnaldo
 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> Thanks,
> 
> 	Ingo
