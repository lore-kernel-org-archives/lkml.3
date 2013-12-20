Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3LTIOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:14:04 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49997 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3LTIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:14:01 -0500
Date: Fri, 20 Dec 2013 09:13:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/7] perf tools: A couple of TUI improvements (v2)
Message-ID: <20131220081357.GB12937@gmail.com>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> I was playing with TUI code and added two new windows.  One for
> showing log messages and another for showing header information.
> (Maybe they can be implemented on the GTK code too someday.)
> 
>  * changes from v1)
>   - fix segfault on perf top (Ingo)
>   - split print function handling patch (Arnaldo)
>   - add filtering support on log window (Jiri, Ingo)
> 
> 
> I put the patches on 'perf/tui-v2' branch in my tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any feedbacks are more than welcome, thanks
> Namhyung

Looks pretty good now!

I found four small inconsistencies:

 - in 'perf top' the '?' help text states that there's an 'i' key, but
   that key does nothing.

 - filtering support would be useful in the 'log' window as well :-)

 - in both 'perf top' and 'perf report' neither the 'i' nor the 'l'
   window shows any help window, so one has to guess that '/' does the
   filtering.

 - the hotkeys in the help window used to be ordered alphabetically - 
   they aren't anymore.

While testing 'perf top' I also found three new features which would 
be very nice to have, in case you are interested in implementing them:

 - it would be nice to have a hotkey to start/stop data collection on
   demand, and another hotkey to reset the data. SysProf has this 
   feature, and it's a convenient workflow to have a separate 'data 
   collection' period (possibly done without any screen refresh, so 
   that data collection does not disturb the measured workload), and 
   a quiet 'look at all the data that is not being changed' period. 
   Especially with fast changing workloads the latter can be useful.

 - it would be nice if 'perf report' had a 'view raw trace' window as 
   well, with filtering. That would be roughly equivalent to the 'perf
   report -D' output [but one line per trace entry, i.e. no hex dump
   shown by default], all available within the TUI. With filtering
   that would be a pretty good way to look at various details.

 - it might also be useful if it was possible to save a perf.data from 
   a 'perf top' session - and to start a 'perf top' session from a 
   specific perf.data [and with data collection disabled]. I.e. allow 
   intermediate modes between 'perf top', 'perf report' and 'perf 
   record' profiling workflows, all in a single TUI.

Thanks,

	Ingo
