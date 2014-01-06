Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaAFQwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:52:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:1969 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbaAFQwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:52:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="454334584"
Date: Mon, 6 Jan 2014 08:52:31 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140106165231.GF27909@tassilo.jf.intel.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
 <20140106092929.GA31570@twins.programming.kicks-ass.net>
 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
 <20140106162754.GE27909@tassilo.jf.intel.com>
 <20140106163950.GP31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106163950.GP31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AFAICT its got nothing to do with threaded or not, but only with exec()
> and we do in fact call exec() quite a lot in perf.
> 
> It ensures we do not leak open perf FDs into our child processes. Now
> I'm not entirely sure how we do the exec these days but I think we were
> good about not not leaking them anyway, but more paranoia never really
> hurts.

Then you can just set it with fcntl, which works everywhere, 
instead of doing extra feature tests.

The atomic setup is only needed for threaded programs to avoid
races with other threads doing exec.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
