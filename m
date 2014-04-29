Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaD2LiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933750AbaD2LiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:38:17 -0400
Date: Tue, 29 Apr 2014 13:37:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140429113747.GD1148@krava.brq.redhat.com>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
 <20140429105654.GB1148@krava.brq.redhat.com>
 <20140429111939.GP11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429111939.GP11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 01:19:39PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 29, 2014 at 12:56:54PM +0200, Jiri Olsa wrote:
> > 
> >   perf_counter tools: Propagate signals properly
> >   commit f7b7c26e01e51fe46097e11f179dc71ce7950084
> >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >   Date:   Wed Jun 10 15:55:59 2009 +0200
> > 
> > but I dont think we need to do that
> 
> But but but, then you're re-introducing that fail again? That no good.

well, I was trying the testcase you mentioned in the changelog
and it seemed to work for me.. ;-) I guess I was lucky to hit
the bash time window..

  while :; do perf stat ./foo ; done

so how does this work? bash will kill the loop if perf's wait
status is WIFSIGNALED?

thanks,
jirka
