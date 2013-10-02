Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3JBJVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:21:32 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61575 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3JBJVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:21:30 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 2 Oct 2013 14:50:49 +0530
Message-ID: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
Subject: [QUERY] Why does perf-trace need me to be root?
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

All the other perf tooling can be used as a normal user. At one point,
I had to touch /proc/sys/kernel/perf_event_paranoid to get me numbers
on a PMU event without a symbolic name, but that's about it.
perf-trace seems to be the exception though:

  artagnon|perf-core=:~/src/linux/tools/perf$ perf trace -a -e open
  Couldn't read the raw_syscalls tracepoints information!

The responsible codepath is:

  if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter",
trace__sys_enter) ||
     perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit",
trace__sys_exit)) {

I don't understand much of what's going on, but what can be done to
improve the situation for users?

Thanks.
