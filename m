Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab3CTNXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab3CTNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:23:38 -0400
Date: Wed, 20 Mar 2013 10:23:22 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        feng.tang@intel.com
Subject: Re: Perf tool won't build without libnewt
Message-ID: <20130320132322.GE23423@infradead.org>
References: <20130320121111.GB16485@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130320121111.GB16485@e106331-lin.cambridge.arm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 20, 2013 at 12:11:11PM +0000, Mark Rutland escreveu:
> I attempted to cross-build v3.9-rc3's perf tool for an arm system today, and
> got the following out of the build system:
> 
> CHK libnewt
> Makefile:655: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
> [...]
> builtin-report.c: In function ‘__cmd_report’:
> builtin-report.c:478:15: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
> builtin-report.c:478:15: note: each undeclared identifier is reported only once for each function it appears in
> builtin-report.c: In function ‘cmd_report’:
> builtin-report.c:821:13: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
> make: *** [builtin-report.o] Error 1
> make: *** Waiting for unfinished jobs....
> 
> I've bisected this down to ad0de0971b: "perf report: Enable the runtime
> switching of perf data file".

Can you try with latest tip/perf/urgent, should go to Linus soon.

This cset should fix it:

commit 5f7439e07822942f32b9e0a66f4a3cc9c3e29e67
Author: Michael Ellerman <michael@ellerman.id.au>
Date:   Tue Feb 26 16:02:03 2013 +1100

    perf report: Fix build with NO_NEWT=1

----

	Thanks for reporting!

- Arnaldo
