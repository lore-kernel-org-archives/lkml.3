Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3LWL1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:27:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3LWL1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:27:10 -0500
Date: Mon, 23 Dec 2013 12:26:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/7] perf tools: A couple of TUI improvements (v2)
Message-ID: <20131223112649.GB1183@krava.brq.redhat.com>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
 <20131220173350.GB10902@krava.redhat.com>
 <8761qgdtt2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761qgdtt2.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 02:23:37PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, 20 Dec 2013 18:33:51 +0100, Jiri Olsa wrote:
> > On Fri, Dec 20, 2013 at 02:11:11PM +0900, Namhyung Kim wrote:
> >> Hello,
> >> 
> >> I was playing with TUI code and added two new windows.  One for
> >> showing log messages and another for showing header information.
> >> (Maybe they can be implemented on the GTK code too someday.)
> >> 
> >>  * changes from v1)
> >>   - fix segfault on perf top (Ingo)
> >>   - split print function handling patch (Arnaldo)
> >>   - add filtering support on log window (Jiri, Ingo)
> >> 
> >> 
> >> I put the patches on 'perf/tui-v2' branch in my tree:
> >> 
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> >> 
> >> Any feedbacks are more than welcome, thanks
> >> Namhyung
> >
> > got segfault in perf top:
> > (pressed 'l' and several searches)
> 
> Hmm.. so did you this crash in the log window?  How many logs in the
> window - more than 100 or so?  Could you reproduce it regularly?

I'm on your perf/tui-v3

and reproducing via '$ sudo ./perf top -vvv'

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7fffeb142700 (LWP 21873)]
__GI___libc_free (mem=0x7fffd4488010) at malloc.c:2896
2896      if (chunk_is_mmapped(p))                       /* release mmapped memory. */
(gdb) bt
#0  __GI___libc_free (mem=0x7fffd4488010) at malloc.c:2896
#1  0x00000000004cd1f2 in log_menu__filter (filter=0x7fffeb13eac0 "ia32_sysenter_target", menu=0x7fffeb13ea50) at ui/browsers/log.c:106
#2  log_menu__run (menu=0x7fffeb13ea50) at ui/browsers/log.c:157
#3  tui__log_window () at ui/browsers/log.c:187
#4  0x00000000004ca955 in perf_evsel__hists_browse (evsel=evsel@entry=0x984ad0, nr_events=nr_events@entry=1, 
    helpline=helpline@entry=0x57ca08 "For a higher level overview, try: perf top --sort comm,dso", ev_name=0x984de0 "cycles", 
    left_exits=left_exits@entry=false, hbt=hbt@entry=0x7fffeb141ea0, min_pcnt=min_pcnt@entry=0, env=env@entry=0x985180)
    at ui/browsers/hists.c:1520
#5  0x00000000004cc135 in perf_evlist__tui_browse_hists (evlist=0x8e4840, 
    help=help@entry=0x57ca08 "For a higher level overview, try: perf top --sort comm,dso", hbt=hbt@entry=0x7fffeb141ea0, min_pcnt=0, 
    env=0x985180) at ui/browsers/hists.c:1971
#6  0x0000000000433538 in display_thread_tui (arg=0x7fffffffb270) at builtin-top.c:581
#7  0x00000031c5407c53 in start_thread (arg=0x7fffeb142700) at pthread_create.c:308
#8  0x00000031c48f5dbd in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:113
(gdb) 

doing 'l', couple of Pg(Down|Up)s and searchs '/'

jirka
