Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3KRNZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:25:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3KRNZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:25:18 -0500
Date: Mon, 18 Nov 2013 14:25:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
Message-ID: <20131118132510.GB24375@krava.brq.redhat.com>
References: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
 <20131115054609.GB4514@gmail.com>
 <20131118125945.GA3669@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118125945.GA3669@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 09:59:45AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 15, 2013 at 06:46:09AM +0100, Ingo Molnar escreveu:
> > btw., here's some 'perf top' call graph performance and profiling 
> > quality feedback, with the latest perf code:
> > 
> > 'perf top --call-graph fp' now works very well, using just 0.2% 
> > of CPU time on a fast system:
> > 
> >  4676 mingo     20   0  612m  56m 9948 S     1  0.2   0:00.68 perf                                                                                                        
> > 
> > 'perf top --call-graph dwarf' on the other hand is horrendously 
> > slow, using 20% of CPU time on a 4 GHz CPU:
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND                                                                                                     
> >  4646 mingo     20   0  658m  81m  12m R    19  0.3   0:18.17 perf    
> > 
> > On another system with a 2.4GHz CPU it's taking up 100% of CPU 
> > time (!):
> > 
> >   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                               
> >  8018 mingo     20   0  290320  45220   8520 R  99.5  0.3   0:58.81 perf      
> > 
> > Profiling 'perf top' shows all sorts of very high dwarf 
> > processing overhead:
> 
> Yeah, top dwarf callchain has been so far a proof of concept, it
> exacerbates problems that can be seen on 'report', but since its live,
> we can see it more clearly.
> 
> The work on improving callchain processing, (rb_tree'ing, new comm
> infrastructure) alleviated the problem a bit.
> 
> Tuning the stack size requested from the kernel and using --max-stack
> can help when it is really needed, but yes, work on it is *badly* needed.

agreed ;-)

also there's new remote unwind interface recently added
into libdw, which seems to be faster than libunwind.
I plan on adding this soon.

jirka
