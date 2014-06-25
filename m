Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaFYT0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbaFYT0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:26:43 -0400
Date: Wed, 25 Jun 2014 21:25:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140625192547.GF1153@krava.brq.redhat.com>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403688184-6917-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:23:04AM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Carve out ctype.* and util.* stuff into tools/lib/util/. We're keeping
> those as standalone object files in TOOLS_OBJS and add them to the
> targets that need them.
> 
> This way we don't do lib archives but single objects only.

heya,
got following error;

[jolsa@krava perf]$ make
  BUILD:   Doing 'make -j4' parallel build
  CC       util/pmu.o
  CC       util/parse-events-flex.o
  SUBDIR   /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/
util/pmu.c: In function ‘wordwrap’:
util/pmu.c:788:3: error: implicit declaration of function ‘isspace’ [-Werror=implicit-function-declaration]
   while (isspace(*s))
   ^
cc1: all warnings being treated as errors
make[1]: *** [util/pmu.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2


Anyway, so you moved hex2u64, ctype interface under tools/lib
and made several Makefile changes to compile tools/lib objects.

Besides that we'd need all those changes separated, who is the
other user of this library? I dont see any in the patch.

thanks,
jirka
