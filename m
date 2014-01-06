Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaAFOix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:38:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbaAFOiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:38:50 -0500
Date: Mon, 6 Jan 2014 15:38:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140106143828.GF1183@krava.brq.redhat.com>
References: <1387445666-7821-1-git-send-email-namhyung@kernel.org>
 <20140103132425.GC1190@krava.brq.redhat.com>
 <871u0lftbh.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u0lftbh.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 04:44:18PM +0900, Namhyung Kim wrote:

SNIP

> >> +		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
> >
> > So unless we use trace_seq_do_printf we dont have any
> > notification that this went wrong..?
> 
> Right.
> 
> >
> > How about use some sort of WARN_ONCE any time the state
> > is set != GOOD ?
> 
> I'm not sure what's the right thing to do for that case.  Printing a
> warning message might disturb user's output since it can be in a middle
> of some (other) processing and she doesn't want to print anything during
> the processing for some reason.
> 
> I just thought that it's not so important to print message so keeps the
> error internally until it gets printed.  But I can be wrong as usual...

I think that if she manages to get one of those errors
the perf would fail soon anyway.. so it feels better
to print it out immediately.

jirka
