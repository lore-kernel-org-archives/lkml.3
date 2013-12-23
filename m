Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3LWFXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:23:41 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53362 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWFXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:23:39 -0500
X-AuditID: 9c93017e-b7be0ae000007d1a-d0-52b7c8d92456
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/7] perf tools: A couple of TUI improvements (v2)
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
	<20131220173350.GB10902@krava.redhat.com>
Date: Mon, 23 Dec 2013 14:23:37 +0900
In-Reply-To: <20131220173350.GB10902@krava.redhat.com> (Jiri Olsa's message of
	"Fri, 20 Dec 2013 18:33:51 +0100")
Message-ID: <8761qgdtt2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 20 Dec 2013 18:33:51 +0100, Jiri Olsa wrote:
> On Fri, Dec 20, 2013 at 02:11:11PM +0900, Namhyung Kim wrote:
>> Hello,
>> 
>> I was playing with TUI code and added two new windows.  One for
>> showing log messages and another for showing header information.
>> (Maybe they can be implemented on the GTK code too someday.)
>> 
>>  * changes from v1)
>>   - fix segfault on perf top (Ingo)
>>   - split print function handling patch (Arnaldo)
>>   - add filtering support on log window (Jiri, Ingo)
>> 
>> 
>> I put the patches on 'perf/tui-v2' branch in my tree:
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>> 
>> Any feedbacks are more than welcome, thanks
>> Namhyung
>
> got segfault in perf top:
> (pressed 'l' and several searches)

Hmm.. so did you this crash in the log window?  How many logs in the
window - more than 100 or so?  Could you reproduce it regularly?

>
> 0x14cde0 __memmove_ssse3_back: period++ [addr: 0x14db58, 0xd78, evidx=0] => 10
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x7fffeaf4a700 (LWP 8368)]
> ____rb_erase_color (augment_rotate=<optimized out>, root=<optimized out>, parent=0x157bd70)
>     at ../../lib/rbtree.c:229
> 229                                     rb_set_parent_color(tmp1, parent, RB_BLACK);
> Missing separate debuginfos, use: debuginfo-install
> audit-libs-2.3.2-1.fc19.x86_64 elfutils-libelf-0.156-5.fc19.x86_64
> elfutils-libs-0.156-5.fc19.x86_64 libunwind-1.1-2.fc19.x86_64
> nss-softokn-freebl-3.15.3-1.fc19.x86_64
> numactl-libs-2.0.8-4.fc19.x86_64 perl-libs-5.16.3-266.fc19.x86_64
> python-libs-2.7.5-9.fc19.x86_64 slang-2.2.4-8.fc19.x86_64
> xz-libs-5.1.2-4alpha.fc19.x86_64 zlib-1.2.7-10.fc19.x86_64
> (gdb) bt
> #0  ____rb_erase_color (augment_rotate=<optimized out>, root=<optimized out>, parent=0x157bd70)
>     at ../../lib/rbtree.c:229
> #1  rb_erase (node=node@entry=0x29bb500, root=root@entry=0x946a00) at ../../lib/rbtree.c:397
> #2  0x000000000049e0f4 in hists__collapse_resort (hists=0x9469f8, prog=prog@entry=0x0) at util/hist.c:567
> #3  0x0000000000432135 in perf_top__sort_new_samples (arg=0x7fffffffb270) at builtin-top.c:553
> #4  0x00000000004cb64d in hist_browser__run (hbt=0x7fffeaf49ea0, ev_name=0x946c60 "cycles", 
>     browser=<optimized out>) at ui/browsers/hists.c:340
> #5  perf_evsel__hists_browse (evsel=evsel@entry=0x946950, nr_events=nr_events@entry=1, 
>     helpline=helpline@entry=0x57dc78 "For a higher level overview, try: perf top --sort comm,dso", 
>     ev_name=0x946c60 "cycles", left_exits=left_exits@entry=false, hbt=hbt@entry=0x7fffeaf49ea0, 
>     min_pcnt=min_pcnt@entry=0, env=env@entry=0x947000) at ui/browsers/hists.c:1430
> #6  0x00000000004cd425 in perf_evlist__tui_browse_hists (evlist=0x8e6840, 
>     help=help@entry=0x57dc78 "For a higher level overview, try: perf top --sort comm,dso", 
>     hbt=hbt@entry=0x7fffeaf49ea0, min_pcnt=0, env=0x947000) at ui/browsers/hists.c:1959
> #7  0x0000000000433928 in display_thread_tui (arg=0x7fffffffb270) at builtin-top.c:581
> #8  0x00000031c5407c53 in start_thread (arg=0x7fffeaf4a700) at pthread_create.c:308
> #9  0x00000031c48f5dbd in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:113
> (gdb) 

Looks like not directly related to the log window.. maybe it already
corrupted some memory regions.

One thing I can think of is the perf_log.linemap was reallocated but the
log window accessed an old linemap.

Thanks,
Namhyung
