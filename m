Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3HANfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:35:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab3HANfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:35:53 -0400
Date: Thu, 1 Aug 2013 15:35:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf: Account freq events per cpu
Message-ID: <20130801133549.GC27162@twins.programming.kicks-ass.net>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
 <20130801124658.GC1032@krava.brq.redhat.com>
 <20130801133155.GB27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801133155.GB27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:31:55PM +0200, Peter Zijlstra wrote:
> the branch_stack thing tests ATTACH_TASK, which should also be good, but
> leaves me wonder wth they do for those that are attached to tasks.

Ah found it, in intel_pmu_lbr_enable() we test cpuc->lbr_context against
event->ctx and wipe the LBR if they differ, that should indeed avoid the
leak but isn't sufficient to guarantee sane data as the context swap for
inherited counters can foil this.


