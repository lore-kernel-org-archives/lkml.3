Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbbAIOzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:55:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbbAIOzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:55:46 -0500
Date: Fri, 9 Jan 2015 15:55:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [BUG] perf probe can't insert return kprobe
Message-ID: <20150109145539.GC14750@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I couldn't use following perf command to insert return probe:

  # perf probe -a fork_exit=do_fork%return
  Added new event:
  Failed to write event: Invalid argument
    Error: Failed to add events.


I'm pretty sure I used this command before, so seems like
it's broken. I can still use debugfs tracing interface to
do that:
  # echo 'r:do_fork_entry do_fork' > kprobe_events

I used Arnaldo's latest perf/core and FC20 kernel:

  # uname -a
  Linux krava 3.17.7-200.fc20.x86_64 #1 SMP Wed Dec 17 03:35:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
  # ./perf version
  perf version 3.18.g6a7d78


thanks,
jirka
