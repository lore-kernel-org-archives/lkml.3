Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3JNIlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:41:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51164 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3JNIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:41:36 -0400
X-AuditID: 9c930179-b7c78ae000003065-39-525bae3fdd9c
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<20131013123444.GB1044@krava.brq.redhat.com>
	<87k3hgbgn2.fsf@sejong.aot.lge.com>
	<20131014080108.GA1590@krava.redhat.com>
Date: Mon, 14 Oct 2013 17:41:34 +0900
In-Reply-To: <20131014080108.GA1590@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 14 Oct 2013 10:01:08 +0200")
Message-ID: <87bo2sb5xd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 14 Oct 2013 10:01:08 +0200, Jiri Olsa wrote:
> On Mon, Oct 14, 2013 at 01:50:09PM +0900, Namhyung Kim wrote:
>> On Sun, 13 Oct 2013 14:34:44 +0200, Jiri Olsa wrote:
>> > I put perf archive and data output in here if you're interested:
>> > http://people.redhat.com/jolsa/cc/
>> 
>> I can't download the data output (but the archive is fine).
>> 
>>   $ curl http://people.redhat.com/jolsa/cc/perf.data
>>   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
>>   <html><head>
>>   <title>403 Forbidden</title>
>>   </head><body>
>>   <h1>Forbidden</h1>
>>   <p>You don't have permission to access /jolsa/cc/perf.data
>>   on this server.</p>
>>   <hr>
>>   <address>Apache Server at people.redhat.com Port 80</address>
>>   </body></html>
>
> oops, should be fixed now.. haven't checked persmissions :-\

I got it now, thanks.

But I couldn't reproduce the segfault (both for TUI and stdio).
Do you have any scenario?

  # ========
  # captured on: Mon Oct 14 17:30:03 2013
  # hostname : dhcp-26-214.brq.redhat.com
  # os release : 3.12.0-rc2+
  # perf version : 3.12.rc2.g9de23a
  # arch : x86_64
  # nrcpus online : 2
  # nrcpus avail : 2
  # cpudesc : Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
  # cpuid : GenuineIntel,6,23,10
  # total memory : 1968996 kB
  # cmdline : /home/jolsa/linux-perf/tools/perf/perf record -g -e cycles:pp make -j 
  # event : name = cycles:pp, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 
  # HEADER_CPU_TOPOLOGY info available, use -I to display
  # pmu mappings: cpu = 4, software = 1, tracepoint = 2, breakpoint = 5
  # ========
  #
  # Samples: 285K of event 'cycles:pp'
  # Event count (approx.): 173578957575
  ...

Thanks,
Namhyung
