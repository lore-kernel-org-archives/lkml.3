Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3APKZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:25:07 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63558 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab3APKZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:25:05 -0500
X-AuditID: 9c930179-b7b54ae000000e44-85-50f67ffef842
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
Date: Wed, 16 Jan 2013 19:25:02 +0900
In-Reply-To: <20130115183405.GD5826@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 15 Jan 2013 15:34:05 -0300")
Message-ID: <87a9s9mnlt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:34:05 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 15, 2013 at 04:31:52PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Show group members' overhead also when showing the leader's if event
>> group is enabled.  Use macro for defining hpp functions which looks
>> almost identical.
>> 
>> Unlike other hpp backend, GTK+ needs to print dummy 0.00% output since
>> it's displayed with variable width fonts.  So that simply skipping
>> with %*s trick won't work well here.
>
> I'm illiterate on GTK+ internals, but I kinda expected that it could
> provide a way to avoid such things, i.e. a way to position the cursor
> in such circumstance without having to actually print the '0.00%' :-\

I also don't understand the internals so I just guess that it might
(only?) be acheived by adding new columns for each group members.

Of course I'm fine with this way too, but one thing I'm not sure is how
the column header look like.  Currently "Overhead" is displayed on the
header for period of every group members - say, there's a group consists
of two events: {branches,branch-misses}.  It'd look like:

        Overhead  Command  Shared Object   Symbol
  ..............  .......  .............  .......
  98.32%  31.16%    a.out          a.out  [.] foo


Maybe we can use simple event name for this, but it seems it makes to
hard to recognize which one is which if other output options like
--show-total-period, --showcpuutilization and/or --show-nr-samples.

Adding current header name to event name will fix the problem but it
probably occupies too much screen width especially for long named
tracepoint or PMU-specific events like
"compaction:mm_compaction_isolate_migratepages".

  Overhead/branches  Overhead/branch-misses  sys/branches  sys/branch-misses  usr/branches  usr/branch-misses  Command  Shared Object   Symbol
  .................  ......................  ............  .................  ............  .................  .......  .............  .......
             98.32%                  31.16%         0.00%              0.00%        98.32%             31.16%    a.out          a.out  [.] foo


If you have a better idea or other way to place the cursor without
printing bogus 0.00% on GTK, please let me know.

Thanks,
Namhyung
