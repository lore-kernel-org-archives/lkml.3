Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaKKK1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:27:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaKKK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:27:50 -0500
Date: Tue, 11 Nov 2014 11:27:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on
 NO_LIBELF=1
Message-ID: <20141111102745.GJ10501@worktop.programming.kicks-ass.net>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
 <1415372259.1648.51.camel@leonhard>
 <20141107173718.GD29390@twins.programming.kicks-ass.net>
 <87mw7zva3c.fsf@sejong.aot.lge.com>
 <20141110121105.GL3337@twins.programming.kicks-ass.net>
 <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 01:24:38PM +0900, Namhyung Kim wrote:
> > What I was saying, why not have a util/symbol.c change that disregards
> > all DSOs with 0 symbols in.
> 
> The util/symbol.c doesn't need this because it can handle vmlinux
> reliably.  So after reading symbol table, it'll use the dso if it
> actually contains symbols or fallback to next dso if it has 0 symbols.
> IOW it already disregards all dsos with 0 symbols in.

Well, it could not could it.. it readily proceeded with 0 symbols in my
case. It did _not_ fallback to kallsyms.
