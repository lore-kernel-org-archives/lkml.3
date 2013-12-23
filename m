Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3LWFNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:13:09 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51663 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWFNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:13:06 -0500
X-AuditID: 9c93017e-b7be0ae000007d1a-77-52b7c660b2d6
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/7] perf tools: A couple of TUI improvements (v2)
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
	<20131220081357.GB12937@gmail.com>
Date: Mon, 23 Dec 2013 14:13:04 +0900
In-Reply-To: <20131220081357.GB12937@gmail.com> (Ingo Molnar's message of
	"Fri, 20 Dec 2013 09:13:57 +0100")
Message-ID: <87a9fsduan.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, 20 Dec 2013 09:13:57 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
> Looks pretty good now!
>
> I found four small inconsistencies:
>
>  - in 'perf top' the '?' help text states that there's an 'i' key, but
>    that key does nothing.

Yes, I can split the help text for perf top and perf report as some keys
only work for perf report already.

>
>  - filtering support would be useful in the 'log' window as well :-)

It's for the 'log' window.  Did you mean the 'header' window? :)

>
>  - in both 'perf top' and 'perf report' neither the 'i' nor the 'l'
>    window shows any help window, so one has to guess that '/' does the
>    filtering.

Okay, I'll add the help.

>
>  - the hotkeys in the help window used to be ordered alphabetically - 
>    they aren't anymore.

Will be fixed with the split.

>
> While testing 'perf top' I also found three new features which would 
> be very nice to have, in case you are interested in implementing them:

Hmm.. looks like features for the long-term plan.  Not sure I can work
on it soon.

>
>  - it would be nice to have a hotkey to start/stop data collection on
>    demand, and another hotkey to reset the data. SysProf has this 
>    feature, and it's a convenient workflow to have a separate 'data 
>    collection' period (possibly done without any screen refresh, so 
>    that data collection does not disturb the measured workload), and 
>    a quiet 'look at all the data that is not being changed' period. 
>    Especially with fast changing workloads the latter can be useful.

I'm not sure I understood correctly.  So do you want start/stop the
'record' part or 'report' part with hotkeys?

>
>  - it would be nice if 'perf report' had a 'view raw trace' window as 
>    well, with filtering. That would be roughly equivalent to the 'perf
>    report -D' output [but one line per trace entry, i.e. no hex dump
>    shown by default], all available within the TUI. With filtering
>    that would be a pretty good way to look at various details.

Do you want something like 'perf script'? :)

>
>  - it might also be useful if it was possible to save a perf.data from 
>    a 'perf top' session - and to start a 'perf top' session from a 
>    specific perf.data [and with data collection disabled]. I.e. allow 
>    intermediate modes between 'perf top', 'perf report' and 'perf 
>    record' profiling workflows, all in a single TUI.

Someday.. :)


Thanks,
Namhyung
