Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3LUWxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 17:53:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:51319 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756144Ab3LUWxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 17:53:37 -0500
Date: Sat, 21 Dec 2013 17:53:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: A few trace event triggers fixes
Message-ID: <20131221175331.15441428@gandalf.local.home>
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013 16:43:59 -0600
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> This patchset fixes a few sparse warnings and build problems seen
> under certain configurations, as uncovered by the kbuild test robot.
> 
> Applies to linux-trace.git ftrace/core.
> 
> The following changes since commit 611e9015501ab9597d6a43253813d4efd90936de:
> 
>   tracing: Add documentation for trace event triggers (2013-12-20 23:24:20 -0500)

Thanks Tom, but I'm also in the process of fixing these up ;-)

> 
> are available in the git repository at:
> 
>   git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/event-triggers-ftrace-core-kbuild-robot-fixes
>   http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/event-triggers-ftrace-core-kbuild-robot-fixes
> 
> Tom Zanussi (3):
>   tracing: Move tracing_alloc_snapshot() declaration to tracing.h

Heh, my fix was just to return -1, but I'll use your fix instead.

>   tracing: Add and use event_trigger_lseek()

I've actually changed added a generic tracing_lseek() for all to use.

I'll use my patch instead.

>   tracing: Add rcu annotation for event_trigger_data.filter

Running sparse with this change required more than just the added
__rcu that you added (as I did too). I'll fix this up and start testing
as well. I'll post the two patches I did just for you to give an ack
on.

Thanks!

-- Steve

> 
>  include/linux/kernel.h              |  2 --
>  kernel/trace/trace.h                |  3 ++-
>  kernel/trace/trace_events_trigger.c | 15 ++++++++++++++-
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 

