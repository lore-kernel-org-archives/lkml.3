Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaIVXm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:42:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33316 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaIVXmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:42:55 -0400
X-AuditID: 85900ec0-be8f3b9000002d32-fd-5420b3fbc3d3
Subject: [PATCH v5 0/4] ftrace: Add a ftrace test collection
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 23:42:48 +0000
Message-ID: <20140922234248.23415.36560.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the collection of testcases for ftrace version 5.
This is just a small update.

  - Fix a TODO item, since this already integrated to kselftest.
  - Print the test name at the first line.
  - Add Shuah's acked-by. (Thanks!)

ftracetest is a shell(dash) script for testing ftrace features.
It will be required to add a unit test for each new feature
after this is merged, because of preventing regressions.

Thank you,

---

Masami Hiramatsu (4):
      ftracetest: Initial commit for ftracetest
      ftracetest: Add ftrace basic testcases
      ftracetest: Add kprobe basic testcases
      ftracetest: Add POSIX.3 standard and XFAIL result codes


 MAINTAINERS                                        |    1 
 tools/testing/selftests/Makefile                   |    1 
 tools/testing/selftests/ftrace/Makefile            |    7 +
 tools/testing/selftests/ftrace/README              |   82 +++++++
 tools/testing/selftests/ftrace/ftracetest          |  251 ++++++++++++++++++++
 tools/testing/selftests/ftrace/samples/fail.tc     |    4 
 tools/testing/selftests/ftrace/samples/pass.tc     |    3 
 .../testing/selftests/ftrace/samples/unresolved.tc |    4 
 .../selftests/ftrace/samples/unsupported.tc        |    3 
 tools/testing/selftests/ftrace/samples/untested.tc |    3 
 tools/testing/selftests/ftrace/samples/xfail.tc    |    3 
 .../selftests/ftrace/test.d/00basic/basic1.tc      |    3 
 .../selftests/ftrace/test.d/00basic/basic2.tc      |    7 +
 .../selftests/ftrace/test.d/00basic/basic3.tc      |    8 +
 .../ftrace/test.d/kprobe/add_and_remove.tc         |   11 +
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |   13 +
 tools/testing/selftests/ftrace/test.d/template     |    9 +
 17 files changed, 413 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/Makefile
 create mode 100644 tools/testing/selftests/ftrace/README
 create mode 100755 tools/testing/selftests/ftrace/ftracetest
 create mode 100644 tools/testing/selftests/ftrace/samples/fail.tc
 create mode 100644 tools/testing/selftests/ftrace/samples/pass.tc
 create mode 100644 tools/testing/selftests/ftrace/samples/unresolved.tc
 create mode 100644 tools/testing/selftests/ftrace/samples/unsupported.tc
 create mode 100644 tools/testing/selftests/ftrace/samples/untested.tc
 create mode 100644 tools/testing/selftests/ftrace/samples/xfail.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic1.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/template

--
