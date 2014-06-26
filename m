Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaFZVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:01:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:44716 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaFZVB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:01:57 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/5] perf/core improvements and a fix
Date: Thu, 26 Jun 2014 18:01:42 -0300
Message-Id: <1403816507-12943-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 1c92f88542faa3ae4f970c548b4fe8275a45201b:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-06-25 07:44:19 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to e281a9606d7073c517f2571e83faaff029ddc1cf:

  perf trace: Add possibility to switch off syscall events (2014-06-26 17:48:07 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

New features:

. Add support for pagefault tracing in 'trace', please see multiple examples
  in the changeset messages (Stanislav Fomichev).

User visible:

. Fallback to syscalls:* when raw_syscalls:* is not available in the perl and
  python perf scripts. (Daniel Bristot de Oliveira)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Daniel Bristot de Oliveira (1):
      perf scripts: Fallback to syscalls:* when raw_syscalls:* is not available

Stanislav Fomichev (4):
      perf trace: Add perf_event parameter to tracepoint_handler
      perf trace: Add support for pagefault tracing
      perf trace: Add pagefaults record and replay support
      perf trace: Add possibility to switch off syscall events

 tools/perf/Documentation/perf-trace.txt            |  46 ++++
 tools/perf/builtin-trace.c                         | 237 +++++++++++++++++----
 tools/perf/scripts/perl/bin/failed-syscalls-record |   3 +-
 tools/perf/scripts/perl/failed-syscalls.pl         |   5 +
 .../python/bin/failed-syscalls-by-pid-record       |   3 +-
 tools/perf/scripts/python/bin/sctop-record         |   3 +-
 .../python/bin/syscall-counts-by-pid-record        |   3 +-
 .../perf/scripts/python/bin/syscall-counts-record  |   3 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   5 +
 tools/perf/scripts/python/sctop.py                 |   5 +
 tools/perf/scripts/python/syscall-counts-by-pid.py |   5 +
 tools/perf/scripts/python/syscall-counts.py        |   5 +
 12 files changed, 280 insertions(+), 43 deletions(-)
