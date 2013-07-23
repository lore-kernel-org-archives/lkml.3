Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3GWMoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:44:09 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39836 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3GWMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:44:07 -0400
Date: Tue, 23 Jul 2013 14:44:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 8/8] watchdog: Remove hack to make full dynticks working
Message-ID: <20130723124400.GA10278@somewhere>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-9-git-send-email-fweisbec@gmail.com>
 <20130723123331.GE126784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723123331.GE126784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:33:31AM -0400, Don Zickus wrote:
> On Tue, Jul 23, 2013 at 02:31:06AM +0200, Frederic Weisbecker wrote:
> > A perf event can be used without forcing the tick to
> > stay alive if it doesn't use a frequency but a sample
> > period and if it doesn't throttle (raise storm of events).
> > 
> > Since the lockup detector neither use a perf event frequency
> > nor should ever throttle due to its high period, it can now
> > run concurrently with the full dynticks feature.
> 
> Thanks.  Dumb question, I keep wondering if the lockup detector would be
> better or worse off if it used the perf event frequency as opposed to
> using a sample period?  The idea is it could follow the varying cpu
> frequencies better (and probably simplify some of the code too).
> 
> Acked-by: Don Zickus <dzickus@redhat.com>

Thanks!

IIRC we tried that and I believe the issue was that perf did not
support frequency below 1. So probably the limitation was that it had to
fire at least once per sec.

Also if you do that, we fall into the full dynticks problem again.
