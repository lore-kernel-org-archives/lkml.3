Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaKGRha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:37:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:37729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaKGRh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:37:29 -0500
Date: Fri, 7 Nov 2014 18:37:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on
 NO_LIBELF=1
Message-ID: <20141107173718.GD29390@twins.programming.kicks-ass.net>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
 <1415372259.1648.51.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415372259.1648.51.camel@leonhard>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:57:39PM +0900, Namhyung Kim wrote:

> > Why does this live in the minimal implementation; should we not always
> > discard ELF files with 0 symbols?
> > 
> > Suppose I have a vmlinux but removed all symbols from it; I want it to
> > fall back to kallsyms too.
> 
> I'm not sure I understood what you said correctly.  With this change,
> dso__load_kernel_sym() always ends up calling dso__load_kallsyms() since
> dso__load_vmlinux() will always return 0;
> 
> So I think you'll fall back to kallsyms even though you have a vmlinux
> with symbol.  This makes dso__load_sym() in the patch 2/3 simpler IMHO.

But why have it specific to the minimal elf thing? Why not discard any
DSO with 0 symbols and try the next option to acquire symbols?
