Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaKKNDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:03:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:58134 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbaKKNDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:03:30 -0500
Date: Tue, 11 Nov 2014 10:03:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on
 NO_LIBELF=1
Message-ID: <20141111130326.GT18464@kernel.org>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
 <1415372259.1648.51.camel@leonhard>
 <20141107173718.GD29390@twins.programming.kicks-ass.net>
 <87mw7zva3c.fsf@sejong.aot.lge.com>
 <20141110121105.GL3337@twins.programming.kicks-ass.net>
 <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
 <20141111102745.GJ10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111102745.GJ10501@worktop.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 11, 2014 at 11:27:45AM +0100, Peter Zijlstra escreveu:
> On Tue, Nov 11, 2014 at 01:24:38PM +0900, Namhyung Kim wrote:
> > > What I was saying, why not have a util/symbol.c change that disregards
> > > all DSOs with 0 symbols in.

> > The util/symbol.c doesn't need this because it can handle vmlinux
> > reliably.  So after reading symbol table, it'll use the dso if it
> > actually contains symbols or fallback to next dso if it has 0 symbols.
> > IOW it already disregards all dsos with 0 symbols in.

> Well, it could not could it.. it readily proceeded with 0 symbols in my
> case. It did _not_ fallback to kallsyms.

Right, testing a fix for the problem I described on my last message.

- Arnaldo
