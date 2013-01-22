Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3AVF6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:58:40 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64253 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3AVF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:58:39 -0500
X-AuditID: 9c930179-b7d01ae000004006-4c-50fe2a8ded28
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 08/13] perf gtk/browser: Add support for event group view
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
	<1358235117-12803-9-git-send-email-namhyung@kernel.org>
	<20130115183405.GD5826@ghostprotocols.net>
	<87a9s9mnlt.fsf@sejong.aot.lge.com>
	<20130116182859.GO5826@ghostprotocols.net>
Date: Tue, 22 Jan 2013 14:58:36 +0900
In-Reply-To: <20130116182859.GO5826@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 16 Jan 2013 15:28:59 -0300")
Message-ID: <87pq0xkbcj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 16 Jan 2013 15:28:59 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 16, 2013 at 07:25:02PM +0900, Namhyung Kim escreveu:
>> Adding current header name to event name will fix the problem but it
>> probably occupies too much screen width especially for long named
>> tracepoint or PMU-specific events like
>> "compaction:mm_compaction_isolate_migratepages".
>> 
>>   Overhead/branches  Overhead/branch-misses  sys/branches  sys/branch-misses  usr/branches  usr/branch-misses  Command  Shared Object   Symbol
>>   .................  ......................  ............  .................  ............  .................  .......  .............  .......
>>              98.32%                  31.16%         0.00%              0.00%        98.32%             31.16%    a.out          a.out  [.] foo
>> 
>> 
>> If you have a better idea or other way to place the cursor without
>> printing bogus 0.00% on GTK, please let me know.
>
> Compacting it using an extra line:
>
>  Overhead...............  sys....................  usr....................
>  branches  branch-misses  branches  branch-misses  branches  branch-misses  Command  Shared Object   Symbol
>  ........  .............  ........  .............  ........  .............  .......  .............  .......
>    98.32%         31.16%     0.00%          0.00%    98.32%         31.16%    a.out          a.out  [.] foo
>
> It could even use some reference:
>
>  Overhead.....................  sys.........  usr...........
>  branches(1)  branch-misses(2)  (1)    (2)    (1)     (2)     Command  Shared Object   Symbol
>  ...........  ................  .....  .....  ......  ......  .......  .............  .......
>       98.32%            31.16%  0.00%  0.00%  98.32%  31.16%    a.out          a.out  [.] foo
>
> The (1) could be done with a superscript number or even just using a
> different fore/background color, to use fewer columns.
>
> One other way, that would scale for really long event names, would be to
> have the event list in the first few lines and then:
>
> Events:
> 1. branches
> 2. branch-misses
>
>  Overhead......  sys.........  usr...........
>  (1)     (2)     (1)    (2)    (1)     (2)     Command  Shared Object   Symbol
>  ......  ......  .....  .....  ......  ......  .......  .............  .......
>  98.32%  31.16%  0.00%  0.00%  98.32%  31.16%   a.out           a.out  [.] foo
>
> I think you could switch to/from each of these forms using a hotkey,
> that would influence how the hist_entry__snprintf() routine would work,
> either using perf_evsel__name() or evsel->idx :-)
>
> This way if at some point the user wants to expand/compress the lines,
> it will be possible to do so quickly, just pressing the hotkey.

By saying hotkey, I guess you meant to use it for TUI.  However TUI
doesn't provide those header lines. ;-)

As this extra line (and hotkey) thing might add complexity to the
patchset, I'd like to separate it to a different work and to focus on
the basic feature with current behavior.  Is it acceptable for you?

Thanks,
Namhyung
