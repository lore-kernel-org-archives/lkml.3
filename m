Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FYTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:16:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55530 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3FYTQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:16:57 -0400
Date: Tue, 25 Jun 2013 21:16:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130625191654.GH4855@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130625175729.GI21579@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 07:57:29PM +0200, Robert Richter wrote:
> But what options there are to detach the event from all processes and
> make it persistent?

Something like this:

	ioctl(fd, PERF_EVENT_IOC_DETACH, 0);

I guess this could simply set the persistent flag so that the rest of
the perf code knows not to destroy event buffers etc.

I don't have an idea about the reattaching though because you don't have
a file descriptor there.

Maybe for that we could really use the sys_perf_event_open() with flags
set to PERF_FLAG_PERSISTENT to note that we want to reattach to the
persistent event instead of opening a new one.

Something to that effect...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
