Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaBLHXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:23:37 -0500
Received: from ozlabs.org ([203.10.76.45]:54417 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaBLHXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:23:36 -0500
Date: Wed, 12 Feb 2014 18:23:16 +1100
From: Anton Blanchard <anton@samba.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 06/35] perf hists: Leave symbol addr hist bucket auto
 alloc to symbol layer
Message-ID: <20140212182316.44a10ca6@kryten>
In-Reply-To: <1387566550-3524-7-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
	<1387566550-3524-7-git-send-email-acme@infradead.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Since now symbol__addr_inc_samples() does the auto alloc, no need to
> do it prior to calling hist_entry__inc_addr_samples.

perf annotate on a ppc64 build (no TUI) is failing. I get zero output.
I haven't had a chance to look closer, but I used the following git
bisect test script to isolate:


#!/bin/sh

cd tools/perf

make || exit 125

PERF=./perf

$PERF record -a sleep 5

if [ -z "`$PERF annotate`" ]; then
	exit 1
else
	exit 0
fi


Anton
