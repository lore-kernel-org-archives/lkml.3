Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaEHSXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:23:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45181 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaEHSXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:23:51 -0400
Date: Thu, 8 May 2014 20:23:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140508182344.GG12548@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
 <20140506185359.GE25013@pd.tnic>
 <20140507164407.GG32718@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140507164407.GG32718@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 06:44:07PM +0200, Robert Richter wrote:
> With transparently I mean that the process even does not know that the
> same event is already running by another process. The kernel detects
> this and maps the request to that event and buffer. Of course the
> event's buffer must be at least readonly to be shared for this.

Yes.

> This could be a mechanism to connect to persistent events. The kernel
> detects by type and attr that the requested event is already running
> persistent and maps to it.
> 
> But at the moment persistent events can only be shared using
> 
>  attr.type = PERF_TYPE_PERSISTENT
>  attr.config = id
> 
> So the above is more an alternative to connect to persistent events
> and the question is, which one to use. Presumable the easiest first,
> which is the current implementation.

Well, there is no trivial way to share event buffers if they're not
read-only AFAICT.

But in questions like this, we always have to step one step back and ask
ourselves: what are the use cases for shared events and after we have
enumerated them, to design the kernel side so that it supports them.

So, do we want anything else besides shared, read-only events?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
