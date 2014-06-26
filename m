Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaFZRth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:49:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16843 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753555AbaFZRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:49:36 -0400
Date: Thu, 26 Jun 2014 13:49:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [for-next][PATCH v2 1/3] tracing: Fix syscall_*regfunc() vs
 copy_process() race
Message-ID: <20140626134934.20d1d28f@gandalf.local.home>
In-Reply-To: <871tue7q4y.fsf@sejong.aot.lge.com>
References: <20140620104518.722157733@goodmis.org>
	<20140620104711.140660296@goodmis.org>
	<871tue7q4y.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 15:55:41 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> On Fri, 20 Jun 2014 06:45:19 -0400, Steven Rostedt wrote:
> > From: Oleg Nesterov <oleg@redhat.com>
> >
> > syscall_regfunc() and syscall_unregfunc() should set/clear
> > TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> > with copy_process() and miss the new child which was not added to
> > the process/thread lists yet.
> >
> > Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> > under tasklist.
> 
> s/tasklist/tasklist_lock/ ?
> 
> Probably I'm too late..

Yeah, but it's just a change log, and I think people can figure it out
(I hope).

-- Steve
