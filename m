Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaJXAoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:44:22 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:49501 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJXAoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:44:21 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain post-unwinding for libunwind (v4)
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
	<20141013181158.GA28191@krava.redhat.com>
	<20141015192441.GR3198@kernel.org> <20141015200630.GT3198@kernel.org>
	<87iojcga58.fsf@sejong.aot.lge.com>
	<20141023233542.GR14687@kernel.org>
Date: Fri, 24 Oct 2014 09:44:17 +0900
In-Reply-To: <20141023233542.GR14687@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 23 Oct 2014 20:35:42 -0300")
Message-ID: <877fzqe1pa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 20:35:42 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 22, 2014 at 10:34:27AM +0900, Namhyung Kim escreveu:
>> Hi Arnaldo,
>> 
>> On Wed, 15 Oct 2014 17:06:30 -0300, Arnaldo Carvalho de Melo wrote:
>> > Next time please run: (I'm fixing this up this time)
>> >
>> > [acme@zoo linux]$ time make -C tools/perf build-test
>> ...
>> > In file included from util/machine.c:14:0:
>> > util/unwind.h: In function ‘unwind__prepare_access’:
>> > util/unwind.h:47:57: error: unused parameter ‘thread’
>> > [-Werror=unused-parameter]
>> >  static inline int unwind__prepare_access(struct thread *thread)
>> >                                                          ^
>> > util/unwind.h: In function ‘unwind__finish_access’:
>> > util/unwind.h:52:57: error: unused parameter ‘thread’
>> > [-Werror=unused-parameter]
>> >  static inline void unwind__finish_access(struct thread *thread) {}
>> >                                                          ^
>> > cc1: all warnings being treated as errors
>> > make[3]: *** [util/machine.o] Error 1
>> > make[3]: *** Waiting for unfinished jobs....
>> > make[2]: *** [all] Error 2
>> >   test: test -x ./perf
>> > make[1]: *** [make_no_libelf] Error 1
>> > make: *** [build-test] Error 2
>> > make: Leaving directory `/home/git/linux/tools/perf'
>> 
>> So it seems you didn't include the patch 3/5 which is the key of this
>> series..  Could you please check it again?
>
> Yeah, I'm adding it now, and in this case as well the __maybe_unused was
> missing, added.

It was my bad to miss the annotation, sorry.


>
> I'll push later and will drop you a note, so that you can, please, check
> if the end result is sane.

Thank you!

> Sorry for the slip up,

No problem. :)

Thanks,
Namhyung
