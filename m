Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIRMEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:04:50 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60571 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaIRMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:04:48 -0400
Subject: [PATCH v4 0/4] ftrace: Add a ftrace test collection
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 18 Sep 2014 12:04:37 +0000
Message-ID: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the collection of testcases for ftrace version 4.
In this version, I moved all scripts under the 
tools/testing/selftest :)

Updates are:
 - Use errexit option to simplify tests.
 - Use signal-based result notify for result codes (except PASS/FAIL).
 - Fix README according to Steven's comments.
 - Move under the tools/testing/selftest.
 - Remove XPASS support (unless someone really needs it)

ftracetest is a shell(dash) script for testing ftrace features.
It will be required to add a unit test for each new feature
after this is merged, because of preventing feature regressions.

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
 tools/testing/selftests/ftrace/ftracetest          |  249 ++++++++++++++++++++
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
 17 files changed, 411 insertions(+)
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

