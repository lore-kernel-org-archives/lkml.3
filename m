Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaAPJjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:39:49 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51323 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPJjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:39:46 -0500
Subject: [PATCH -tip  0/3] perf-probe bugfixes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 16 Jan 2014 09:39:42 +0000
Message-ID: <20140116093942.24403.50992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of bugfixes reported by David Ahern :)
This fixes several memory leaks on exiting program, and
cleanup code clones.

---

Masami Hiramatsu (3):
      [BUGFIX] perf-probe: Release allocated probe_trace_event if failed
      [BUGFIX] perf-probe: Release all dynamically allocated parameters
      [CLEANUP] perf-tools: Export elf_section_by_name and reuse


 tools/perf/builtin-probe.c    |   48 ++++++++++++++++--
 tools/perf/util/probe-event.c |  111 +++++++++++++++++++++++------------------
 tools/perf/util/probe-event.h |    6 ++
 tools/perf/util/symbol-elf.c  |    5 +-
 tools/perf/util/symbol.h      |    5 ++
 tools/perf/util/unwind.c      |   20 +------
 6 files changed, 121 insertions(+), 74 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

