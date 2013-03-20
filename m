Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3CTNie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:38:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48779 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3CTNid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:38:33 -0400
Date: Wed, 20 Mar 2013 13:38:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "feng.tang@intel.com" <feng.tang@intel.com>
Subject: Re: Perf tool won't build without libnewt
Message-ID: <20130320133820.GA15279@e106331-lin.cambridge.arm.com>
References: <20130320121111.GB16485@e106331-lin.cambridge.arm.com>
 <20130320132322.GE23423@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130320132322.GE23423@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 01:23:22PM +0000, Arnaldo Carvalho de Melo wrote:
> Em Wed, Mar 20, 2013 at 12:11:11PM +0000, Mark Rutland escreveu:
> > I attempted to cross-build v3.9-rc3's perf tool for an arm system today, and
> > got the following out of the build system:
> > 
> > CHK libnewt
> > Makefile:655: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
> > [...]
> > builtin-report.c: In function ‘__cmd_report’:
> > builtin-report.c:478:15: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
> > builtin-report.c:478:15: note: each undeclared identifier is reported only once for each function it appears in
> > builtin-report.c: In function ‘cmd_report’:
> > builtin-report.c:821:13: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
> > make: *** [builtin-report.o] Error 1
> > make: *** Waiting for unfinished jobs....
> > 
> > I've bisected this down to ad0de0971b: "perf report: Enable the runtime
> > switching of perf data file".
> 
> Can you try with latest tip/perf/urgent, should go to Linus soon.
> 
> This cset should fix it:

Indeed it does.

> 
> commit 5f7439e07822942f32b9e0a66f4a3cc9c3e29e67
> Author: Michael Ellerman <michael@ellerman.id.au>
> Date:   Tue Feb 26 16:02:03 2013 +1100
> 
>     perf report: Fix build with NO_NEWT=1
> 
> ----
> 
> 	Thanks for reporting!
> 
> - Arnaldo

Cheers,
Mark.
