Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3KOGGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:06:55 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52561 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3KOGGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:06:47 -0500
Date: Fri, 15 Nov 2013 07:06:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
Message-ID: <20131115060643.GA9237@gmail.com>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
 <1384460715-23198-11-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384460715-23198-11-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> +--force-per-cpu::
> + Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
> + -t or -u options) per-thread mmaps are created.  This option overrides that and
> + forces per-cpu mmaps.  A side-effect of that is that inheritance is
> + automatically enabled.  Add the -i option also to disable inheritance.

So I still haven't seen an explanation why it's called 'force' 
anything. AFAICS nothing is 'forced' really, this is simply another 
trace-ringbuffer setup method, right?

And I also raised why this shouldn't be the default event tracing 
method instead of a weird config option. Per-cpu tracing is cache 
compact, it is easier to size properly and in general it is pretty 
easy to think about. (It also has less of the TSC timestamp ordering 
problems as per thread tracing, at least in theory.)

Is there something that makes per cpu tracing undesirable as the 
default?

Thanks,

	Ingo
