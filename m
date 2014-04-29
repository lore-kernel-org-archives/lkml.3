Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbaD2LdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:33:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:58080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455AbaD2LdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:33:08 -0400
Date: Tue, 29 Apr 2014 13:33:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140429113304.GA13658@twins.programming.kicks-ass.net>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
 <20140429105654.GB1148@krava.brq.redhat.com>
 <20140429111939.GP11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429111939.GP11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
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

The thing is, just the return value is not sufficient to determine if
the child was interrupted.

See WAIT(2), things like WIFSIGNALED() will not work when you just
propagate the return value, you need to terminate the task with a
signal to propagate this.

