Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaKRLAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:00:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbaKRLAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:00:34 -0500
Date: Tue, 18 Nov 2014 12:00:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141118110007.GF27645@krava.brq.redhat.com>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141118104416.GE27645@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:44:16AM +0100, Jiri Olsa wrote:
> On Mon, Nov 17, 2014 at 06:34:57PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Nov 12, 2014 at 06:05:18PM -0800, Andi Kleen escreveu:
> > > [Reworks to address all the review feedback. Rebased to latest tree]
> > > [Just a repost after a rebase]
> > > [Even more review feedback and some bugs addressed.]
> > > [Only port to changes in perf/core. No other changes.]
> > > [Rebase to latest perf/core]
> > > [Another rebase. No changes]
> > > 
> > > This patchkit implements lbr-as-callgraphs in per freport,
> > > as an alternative way to present LBR information.
> > 
> > Ok, I have this in my perf/core branch, but I need to test it further,
> > as I couldn't get the output that appears on some of the changelogs.
> > 
> > If you could take a look at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> > 
> > To see if I made some mistake, that would be of help,
> > 
> 
> I'm getting compile error for DEBUG=1

looks like the BUILD_BUG_ON_MSG does not work correctly with -O6 we use

jirka

> 
> jirka
> 
> 
> [jolsa@krava perf]$ make DEBUG=1 JOBS=1
>   BUILD:   Doing 'make -j1' parallel build
>   CC       util/machine.o
> In file included from /home/jolsa/kernel.org/linux-perf/tools/perf/util/include/../../../../include/uapi/linux/swab.h:5:0,
>                  from /home/jolsa/kernel.org/linux-perf/tools/perf/util/include/asm/byteorder.h:2,
>                  from /home/jolsa/kernel.org/linux-perf/include/uapi/linux/perf_event.h:19,
>                  from util/../perf.h:7,
>                  from util/callchain.h:4,
>                  from util/machine.c:1:
> util/machine.c: In function ‘remove_loops’:
> /home/jolsa/kernel.org/linux-perf/tools/include/linux/compiler.h:64:20: error: call to ‘__compiletime_assert_1450’ declared with attribute error: Please upgrade the type of the hash table from unsigned char
>     prefix ## suffix();    \
>                     ^
> /home/jolsa/kernel.org/linux-perf/tools/include/linux/compiler.h:69:2: note: in expansion of macro ‘__compiletime_assert’
>   __compiletime_assert(condition, msg, prefix, suffix)
>   ^
> /home/jolsa/kernel.org/linux-perf/tools/include/linux/compiler.h:81:2: note: in expansion of macro ‘_compiletime_assert’
>   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>   ^
> /home/jolsa/kernel.org/linux-perf/tools/include/linux/bug.h:13:37: note: in expansion of macro ‘compiletime_assert’
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^
> util/machine.c:1449:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
>   BUILD_BUG_ON_MSG(PERF_MAX_BRANCH_DEPTH > 127,
>   ^
> make[1]: *** [util/machine.o] Error 1
> make: *** [all] Error 2
