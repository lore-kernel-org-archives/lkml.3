Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaHECp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:45:58 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42682 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaHECp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:45:56 -0400
Subject: [RFC PATCH 0/3] ftrace: Add a ftrace test collection
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 05 Aug 2014 02:45:44 +0000
Message-ID: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to introduce a collection of testcases for ftrace to
avoid regressions.

For a long time, we've tried to stabilize and extend ftrace
tracing infrastructure. This small test framework is a kind of
stabilizing work for ftrace. For the first step, this series
just introduces a few basic testcases. However, it is easy to
add additional tests. I'd like to ask you, ftrace developers,
to add tests for your features to ensure it will not be broken
by future works.

ftracetest is a tiny bash script so that anyone can easily
understand what it does. I think it is better to share and
discuss this tests before growing it.

 - Is it enough to support bash script? (of course you can
   invoke other commands from the script)
 - What's the good naming method of testcases?
 - Is any dependency check required?

BTW, I decided to put this under tools/testing/ftrace instead
of tools/testing/selftests/, because all tests requires root
privilege. It will be one of discussion points. Anyway,
it is easy to integrate this to the selftests.

Thank you,

---

Masami Hiramatsu (3):
      ftracetest: Initial commit for ftracetest
      ftracetest: Add ftrace basic testcases
      ftracetest: Add kprobe basic testcases


 tools/testing/ftrace/README                        |   38 ++++++
 tools/testing/ftrace/ftracetest                    |  133 ++++++++++++++++++++
 tools/testing/ftrace/test.d/basic1.tc              |    3 
 tools/testing/ftrace/test.d/basic2.tc              |    6 +
 tools/testing/ftrace/test.d/basic3.tc              |    8 +
 .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   11 ++
 tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   14 ++
 tools/testing/ftrace/test.d/template               |    4 +
 8 files changed, 217 insertions(+)
 create mode 100644 tools/testing/ftrace/README
 create mode 100755 tools/testing/ftrace/ftracetest
 create mode 100644 tools/testing/ftrace/test.d/basic1.tc
 create mode 100644 tools/testing/ftrace/test.d/basic2.tc
 create mode 100644 tools/testing/ftrace/test.d/basic3.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/busy_check.tc
 create mode 100644 tools/testing/ftrace/test.d/template

--

