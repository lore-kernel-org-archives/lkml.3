Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaJWXfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:35:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:56295 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbaJWXfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:35:52 -0400
Date: Thu, 23 Oct 2014 20:35:42 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
Message-ID: <20141023233542.GR14687@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
 <20141013181158.GA28191@krava.redhat.com>
 <20141015192441.GR3198@kernel.org>
 <20141015200630.GT3198@kernel.org>
 <87iojcga58.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87iojcga58.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 22, 2014 at 10:34:27AM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Wed, 15 Oct 2014 17:06:30 -0300, Arnaldo Carvalho de Melo wrote:
> > Next time please run: (I'm fixing this up this time)
> >
> > [acme@zoo linux]$ time make -C tools/perf build-test
> ...
> > In file included from util/machine.c:14:0:
> > util/unwind.h: In function ‘unwind__prepare_access’:
> > util/unwind.h:47:57: error: unused parameter ‘thread’
> > [-Werror=unused-parameter]
> >  static inline int unwind__prepare_access(struct thread *thread)
> >                                                          ^
> > util/unwind.h: In function ‘unwind__finish_access’:
> > util/unwind.h:52:57: error: unused parameter ‘thread’
> > [-Werror=unused-parameter]
> >  static inline void unwind__finish_access(struct thread *thread) {}
> >                                                          ^
> > cc1: all warnings being treated as errors
> > make[3]: *** [util/machine.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> > make[2]: *** [all] Error 2
> >   test: test -x ./perf
> > make[1]: *** [make_no_libelf] Error 1
> > make: *** [build-test] Error 2
> > make: Leaving directory `/home/git/linux/tools/perf'
> 
> So it seems you didn't include the patch 3/5 which is the key of this
> series..  Could you please check it again?

Yeah, I'm adding it now, and in this case as well the __maybe_unused was
missing, added.

I'll push later and will drop you a note, so that you can, please, check
if the end result is sane.

Sorry for the slip up,

- Arnaldo
