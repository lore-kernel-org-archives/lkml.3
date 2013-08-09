Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967039Ab3HIKdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966522Ab3HIKdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:33:50 -0400
Date: Fri, 9 Aug 2013 12:33:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf: Account freq events globally
Message-ID: <20130809103323.GE1045@krava.brq.redhat.com>
References: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
 <1375460996-16329-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375460996-16329-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 06:29:55PM +0200, Frederic Weisbecker wrote:
> Freq events may not always be affine to a particular CPU. As such,
> account_event_cpu() may crash if we account per cpu a freq event
> that has event->cpu == -1.
> 
> To solve this, lets account freq events globally. In practice
> this doesn't change much the picture because perf tools create
> per-task perf events with one event per CPU by default. Profiling a
> single CPU is usually a corner case so there is no much point in
> optimizing things that way.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.or>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>

no more OOPSes ;-)

Tested-by: Jiri Olsa <jolsa@redhat.com
