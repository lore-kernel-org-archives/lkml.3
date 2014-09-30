Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaI3HQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaI3HQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:16:46 -0400
Date: Tue, 30 Sep 2014 09:16:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH v2 1/2] perf callchain: Create an address space per thread
Message-ID: <20140930071627.GA27883@krava.brq.redhat.com>
References: <1411966692-26648-1-git-send-email-namhyung@kernel.org>
 <20140929083452.GA1223@krava.brq.redhat.com>
 <87vbo5hc3a.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbo5hc3a.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 03:11:21PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Mon, 29 Sep 2014 10:34:52 +0200, Jiri Olsa wrote:
> > On Mon, Sep 29, 2014 at 01:58:11PM +0900, Namhyung Kim wrote:
> >> @@ -37,6 +38,9 @@ struct thread *thread__new(pid_t pid, pid_t tid)
> >>  		thread->cpu = -1;
> >>  		INIT_LIST_HEAD(&thread->comm_list);
> >>  
> >> +		if (unwind__prepare_access(thread) < 0)
> >> +			goto err_thread;
> >
> > So this is something we need to do only for DWARF unwind via libunwind.
> > Do we want some condition to bypass this in for the rest of the cases?
> 
> Ah, you're right, we need to check that before doing this.
> 
> 
> >
> > I think we could check for symbol_conf.use_callchain and for the
> > PERF_SAMPLE_REGS_USER|PERF_SAMPLE_STACK_USER sample types in evlist,
> > something like:
> >
> >   bool has_dwarf_data_for_callchains = symbol_conf.use_callchain && evlist_sample_type_has(evlist, PERF_SAMPLE_REGS_USER|PERF_SAMPLE_STACK_USER)
> 
> Hmm.. it seems that it's hard to get the evlist at this point.  Maybe we
> need to add a field in the symbol_conf or a global variable.. :/

yea, symbol_conf seems ok

jirka
