Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbaHZLPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:15:23 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54230 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaHZLPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:15:22 -0400
Subject: [RFC PATCH v2 0/4] ftrace: Add a ftrace test collection
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 26 Aug 2014 11:15:12 +0000
Message-ID: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the collection of testcases for ftrace version 2.
In this version, I just updated the test framework according
to some discussions on kernel summit testing unconference.

The major updates are:
 - Using dash (busybox shell) instead of bash, because it
   allows us to test on the minimal environments running on 
   cross-arch emulators.
 - Support XFAIL/XPASS/UNSUPPORTED results for testcase.
   Some of ftrace features depend on kconfig and some of
   them do not work by environmental reason.
 - Support partial testing under given directory.

ftracetest is a small dash script for testing ftrace features.
It will be required to add a unit test for each new feature
after this is merged, because of preventing feature regressions.

This version still be out of the selftest. However, at the kernel
summit, I talked with Shuah about that. And since the kselftest
will be the standard kernel unit test framework, I agreed to
move this under the selftest. But I also would like to ask Steven
and Namhyung to agree with it before moving.

Actually, we've already has similar shell-script base testcase
under kselftest, see tools/testing/selftests/sysctl/Makefile.
I think we can mimic it for ftracetest :)

Thank you,

---

Masami Hiramatsu (4):
      ftracetest: Initial commit for ftracetest
      ftracetest: Add ftrace basic testcases
      ftracetest: Add kprobe basic testcases
      ftracetest: Add XFAIL/XPASS/UNSUPPORTED as result code


 tools/testing/ftrace/README                        |   45 +++++
 tools/testing/ftrace/ftracetest                    |  185 ++++++++++++++++++++
 tools/testing/ftrace/test.d/basic1.tc              |    7 +
 tools/testing/ftrace/test.d/basic2.tc              |    8 +
 tools/testing/ftrace/test.d/basic3.tc              |    9 +
 .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   12 +
 tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   14 ++
 tools/testing/ftrace/test.d/template               |    8 +
 8 files changed, 288 insertions(+)
 create mode 100644 tools/testing/ftrace/README
 create mode 100755 tools/testing/ftrace/ftracetest
 create mode 100644 tools/testing/ftrace/test.d/basic1.tc
 create mode 100644 tools/testing/ftrace/test.d/basic2.tc
 create mode 100644 tools/testing/ftrace/test.d/basic3.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/busy_check.tc
 create mode 100644 tools/testing/ftrace/test.d/template

--

