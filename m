Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaAFRQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:16:19 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:37985 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbaAFRQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:16:17 -0500
Message-ID: <1389028547.13828.20.camel@localhost.localdomain>
Subject: Re: [PATCH] perf tools: enable close-on-exec flag on perf file
 descriptor
From: Yann Droneaud <ydroneaud@opteya.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Mon, 06 Jan 2014 18:15:47 +0100
In-Reply-To: <20140106165231.GF27909@tassilo.jf.intel.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
	 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
	 <20140106092929.GA31570@twins.programming.kicks-ass.net>
	 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
	 <20140106162754.GE27909@tassilo.jf.intel.com>
	 <20140106163950.GP31570@twins.programming.kicks-ass.net>
	 <20140106165231.GF27909@tassilo.jf.intel.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 06 janvier 2014 à 08:52 -0800, Andi Kleen a écrit :
> > AFAICT its got nothing to do with threaded or not, but only with exec()
> > and we do in fact call exec() quite a lot in perf.
> > 
> > It ensures we do not leak open perf FDs into our child processes. Now
> > I'm not entirely sure how we do the exec these days but I think we were
> > good about not not leaking them anyway, but more paranoia never really
> > hurts.
> 
> Then you can just set it with fcntl, which works everywhere, 
> instead of doing extra feature tests.
> 
> The atomic setup is only needed for threaded programs to avoid
> races with other threads doing exec.
> 

True.

The purpose of this patch was more about exercising the new flag
proposed for perf_event_open() as a way to demonstrate its usage.
Having it used in the perf code base will likely help to spread it to
other tools based on perf event API. 

Trying to add a close-on-exec enable flag late emphasis it should have
been done earlier and perhaps made the default.

As I wrote in "[PATCH v5 0/7] Getting rid of get_unused_fd() / enable
close-on-exec" [1], setting close-on-exec at open time is easier to
write for the programmer and less error prone than trying to add call to
fcntl() and forget to add it in some code path. (forgetting to add the
proper flag to open() is probably more error prone ... so one might want
to make close-on-exec the *default* for any new API).

[1] http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com

Regards.

-- 
Yann Droneaud
OPTEYA


