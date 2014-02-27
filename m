Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaB0TX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:23:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60900 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaB0TX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:23:56 -0500
Date: Thu, 27 Feb 2014 20:23:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 08/46] kernel: MOve prototype declaration to header file
 include/linux/perf_event.h
Message-ID: <20140227192335.GZ27965@twins.programming.kicks-ass.net>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <137eb91c7ce020384a1fb967c1c8b7eaeded21d8.1393493276.git.rashika.kheria@gmail.com>
 <20140227115414.GD9987@twins.programming.kicks-ass.net>
 <20140227155149.GB26756@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140227155149.GB26756@thin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 07:51:50AM -0800, Josh Triplett wrote:
> On Thu, Feb 27, 2014 at 12:54:14PM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 27, 2014 at 05:02:48PM +0530, Rashika Kheria wrote:
> > > Add prototype declaration of function to header file
> > > include/linux/perf_event.h because it is used by more than one file.
> > > 
> > > This eliminates the following warning in kernel/events/core.c:
> > > kernel/events/core.c:3743:13: warning: no previous prototype for ‘arch_perf_update_userpage’ [-Wmissing-prototypes]
> > 
> > # git grep arch_perf_update_userpage
> > arch/x86/kernel/cpu/perf_event.c:void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> > kernel/events/core.c:void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> > kernel/events/core.c:   arch_perf_update_userpage(userpg, now);
> > 
> > 
> > There's two definitions; one weak, and one usage site.
> > 
> > What gives?
> 
> There's no prototype for the function anywhere, so -Wmissing-prototypes
> rightfully complains.  Adding the prototype to a header included in both
> source files ensures that the function signatures must match, and
> eliminates the warning.

Definitions don't require prior declarations. Only usage without prior
definitions require them.

I still don't see a problem.

Seems to me you're just blindly making a stupid checker happy, just
shoot it in the face.
