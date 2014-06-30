Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaF3KBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:01:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35164 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbaF3KBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:01:19 -0400
Date: Mon, 30 Jun 2014 12:01:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
Message-ID: <20140630100115.GC4766@pd.tnic>
References: <20140630070755.GA4766@pd.tnic>
 <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:39:39AM +0200, Jean Pihet wrote:
> That makes perfect sense since:
> - we need the RAS daemon implementation soon (not just before the
> final blackdown ;-),

Yeah :-)

> - for other tools to exist (like RAS daemon) we need to split out the
> perf code in small units. This will take a significant amount of work
> and time to happen,

Yep, this is what the experience so far tells us. And I'm not proposing
any change to the final objective we're following - to get the perf tool
split. I'm just saying we should "execute another thread" while the perf
tool pipeline of patches stalls, figuratively speaking. :-)

> - the RAS daemon basically is a shrink-down perf with persistent
> events support.

Right.

> How do we start the RAS daemon? As of today we have a prototype
> implementation in C.
>
> Fu Wei, can you confirm about the initial RAS daemon prototype?

Well, do you have it as a standalong program? If so, you can put it in
a repo somewhere and we can start hacking away and playing with it. If
not, we will have to copy the perf code *into* the RAS daemon first so
that we can have a separate source on which we all can work on.

Someone should be a maintainer of some sorts who merges the patches.

And we will continue working on the split so that once the perf tool is
properly separated, we can switch to it in the RAS daemon and drop the
copied code.

This is, to me at least, the best possible thing we can do right now so
as not to slow us all down.

Any other opinions?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
