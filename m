Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3F0If3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:35:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47180 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3F0IfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:35:25 -0400
Date: Thu, 27 Jun 2013 10:35:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130627083522.GA21224@pd.tnic>
References: <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
 <20130626082408.GA20274@pd.tnic>
 <20130626101132.GC21788@rric.localhost>
 <20130626114538.GA4117@gmail.com>
 <20130626124424.GD21788@rric.localhost>
 <8761x014xv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8761x014xv.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 02:46:36PM +0900, Namhyung Kim wrote:
> How about using 2 bits for perfsistent flag, 1 for connecting to an
> existing one, 2 for creating new one.

No need since persistent events don't need to be duplicated. Think of a
tracepoint: the samples you get there are the same, no matter how many
times you enable it.

So, if you open a persistent event which doesn't exist, it gets created.
If you open an existing one, you get read-only access to its buffers. No
need for two bits. Actually, with the detach/attach ioctl we don't even
need a single flag but having it makes the implementation a lot simpler.

> > A problem here is that mmap'ed buffer size (number of pages) must be
> > be equal to the pre-existing buffer size and thus to be known somehow.
> 
> What about also exporting the buffer size via sysfs pmu directory?

Yes, we've been discussing buffer size. The simplest thing is to
hardcode the buffer size so that it is implicitly known to all agents.
However, I don't know whether there is a use case where different buffer
sizes actually make sense. I'd tend to do the simplest thing initially.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
