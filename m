Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3KLXXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:23:00 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44427 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3KLXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:22:53 -0500
Date: Wed, 13 Nov 2013 00:22:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: perf top -u <uid> does not seem to be working
Message-ID: <20131112232249.GA31384@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hm, this is unexpected I think:

  hubble:~> perf top --stdio -u mingo
  Error:
  You may not have permission to collect stats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:
   -1 - Not paranoid at all
    0 - Disallow raw tracepoint access for unpriv
    1 - Disallow cpu events for unpriv
    2 - Disallow kernel profiling for unpriv

  hubble:~> cat /proc/sys/kernel/perf_event_paranoid 
  -1

  hubble:~> perf top --stdio -u
     Error: switch `u' requires a value

   usage: perf top [<options>]

      -u, --uid <user>      user to profile

(perf is the latest version from tip:perf/core)

Thanks,

	Ingo
