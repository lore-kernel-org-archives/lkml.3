Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3AWR77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:59:59 -0500
Received: from mail-ye0-f175.google.com ([209.85.213.175]:51207 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3AWR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:59:58 -0500
Date: Wed, 23 Jan 2013 14:59:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 08/13] perf gtk/browser: Add support for event group view
Message-ID: <20130123175949.GB6687@ghostprotocols.net>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
 <1358235117-12803-9-git-send-email-namhyung@kernel.org>
 <20130115183405.GD5826@ghostprotocols.net>
 <87a9s9mnlt.fsf@sejong.aot.lge.com>
 <20130116182859.GO5826@ghostprotocols.net>
 <87pq0xkbcj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq0xkbcj.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 22, 2013 at 02:58:36PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Wed, 16 Jan 2013 15:28:59 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 16, 2013 at 07:25:02PM +0900, Namhyung Kim escreveu:
> >> Adding current header name to event name will fix the problem but it
> >> probably occupies too much screen width especially for long named
> >> tracepoint or PMU-specific events like
> >> "compaction:mm_compaction_isolate_migratepages".
> >> 
> >>   Overhead/branches  Overhead/branch-misses  sys/branches  sys/branch-misses  usr/branches  usr/branch-misses  Command  Shared Object   Symbol
> >>   .................  ......................  ............  .................  ............  .................  .......  .............  .......
> >>              98.32%                  31.16%         0.00%              0.00%        98.32%             31.16%    a.out          a.out  [.] foo
> >> 
> >> 
> >> If you have a better idea or other way to place the cursor without
> >> printing bogus 0.00% on GTK, please let me know.
> >
> > Compacting it using an extra line:
> >
> >  Overhead...............  sys....................  usr....................
> >  branches  branch-misses  branches  branch-misses  branches  branch-misses  Command  Shared Object   Symbol
> >  ........  .............  ........  .............  ........  .............  .......  .............  .......
> >    98.32%         31.16%     0.00%          0.00%    98.32%         31.16%    a.out          a.out  [.] foo
> >
> > It could even use some reference:
> >
> >  Overhead.....................  sys.........  usr...........
> >  branches(1)  branch-misses(2)  (1)    (2)    (1)     (2)     Command  Shared Object   Symbol
> >  ...........  ................  .....  .....  ......  ......  .......  .............  .......
> >       98.32%            31.16%  0.00%  0.00%  98.32%  31.16%    a.out          a.out  [.] foo
> >
> > The (1) could be done with a superscript number or even just using a
> > different fore/background color, to use fewer columns.
> >
> > One other way, that would scale for really long event names, would be to
> > have the event list in the first few lines and then:
> >
> > Events:
> > 1. branches
> > 2. branch-misses
> >
> >  Overhead......  sys.........  usr...........
> >  (1)     (2)     (1)    (2)    (1)     (2)     Command  Shared Object   Symbol
> >  ......  ......  .....  .....  ......  ......  .......  .............  .......
> >  98.32%  31.16%  0.00%  0.00%  98.32%  31.16%   a.out           a.out  [.] foo
> >
> > I think you could switch to/from each of these forms using a hotkey,
> > that would influence how the hist_entry__snprintf() routine would work,
> > either using perf_evsel__name() or evsel->idx :-)
> >
> > This way if at some point the user wants to expand/compress the lines,
> > it will be possible to do so quickly, just pressing the hotkey.
> 
> By saying hotkey, I guess you meant to use it for TUI.  However TUI
> doesn't provide those header lines. ;-)

See? I was trying to hit two rabbits with one stone, but you realised
that...

> As this extra line (and hotkey) thing might add complexity to the
> patchset, I'd like to separate it to a different work and to focus on
> the basic feature with current behavior.  Is it acceptable for you?

Sure thing.

- Arnaldo
