Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3J1Mm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:42:26 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:45950 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3J1MmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:42:24 -0400
Date: Mon, 28 Oct 2013 09:42:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131028124218.GD16948@ghostprotocols.net>
References: <20131026122414.GA25026@gmail.com>
 <20131028082848.GA276@x4>
 <20131028090236.GA274@x4>
 <20131028093430.GB274@x4>
 <20131028123411.GB16948@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20131028123411.GB16948@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Mon, Oct 28, 2013 at 09:34:11AM -0300, Arnaldo Carvalho de Melo escreveu:
> And then, when reverting it, Stephane forgot to match the number number
> of expected entries to be matched/assigned from 8 to 5, can you try with
> the following patch instead?

Does the wording on this commit log sounds about right to you?

- Arnaldo

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="a.patch"

commit 2fd869f08aec5a8e4cbf01bc3fa345c4e53342d7
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Oct 28 09:38:12 2013 -0300

    perf tools: Fix up /proc/PID/maps parsing
    
    When introducing support for MMAP2 we considered more parts of each map
    representation in /proc/PID/maps, and when disabling it we forgot to
    reduce the number of expected parsed/assigned entries in the sscanf
    call, fix it to expect the right number of desired fields, 5.
    
    Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Based-on-a-patch-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephane Eranian <eranian@google.com>
    Link: http://lkml.kernel.org/n/tip-vrbo1wik997ahjzl1chm3bdm@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 63df031fc9c7..49096ea58a15 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -213,7 +213,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.pgoff,
 		       execname);
 
-		if (n != 8)
+		if (n != 5)
 			continue;
 
 		if (prot[2] != 'x')

--oyUTqETQ0mS9luUI--
