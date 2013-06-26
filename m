Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3FZIMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:12:37 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:37496 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3FZIMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:12:34 -0400
Date: Wed, 26 Jun 2013 10:12:23 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130626081223.GB21788@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625191654.GH4855@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.13 21:16:54, Borislav Petkov wrote:
> On Tue, Jun 25, 2013 at 07:57:29PM +0200, Robert Richter wrote:
> > But what options there are to detach the event from all processes and
> > make it persistent?
> 
> Something like this:
> 
> 	ioctl(fd, PERF_EVENT_IOC_DETACH, 0);
> 
> I guess this could simply set the persistent flag so that the rest of
> the perf code knows not to destroy event buffers etc.
> 
> I don't have an idea about the reattaching though because you don't have
> a file descriptor there.
> 
> Maybe for that we could really use the sys_perf_event_open() with flags
> set to PERF_FLAG_PERSISTENT to note that we want to reattach to the
> persistent event instead of opening a new one.

We get a new fd by opening the persistent event with the syscall.
There would be 2 new ioctls:

 ioctl(fd, PERF_EVENT_IOC_DETACH, 0);
 ioctl(fd, PERF_EVENT_IOC_ATTACH, 0);

This would be fine and reuses existing infrastructure.

-Robert
