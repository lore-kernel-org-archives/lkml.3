Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaIBLGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:06:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47662 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaIBLGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:06:43 -0400
Subject: [RFC PATCH v3 0/4] ftrace: Add a ftrace test collection
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 11:06:32 +0000
Message-ID: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the collection of testcases for ftrace version 3.
This is just some updates and fixes according to the 
discussion at previous version.
  https://lkml.org/lkml/2014/8/26/304

The major updates are:
 - Fix some expressions to work on dash (Thanks Luis!)
 - Support UNRESOLVED/UNTESTED/UNSUPPORTED results for testcase.
   Those are POSIX 1003.3 standard.
   (see http://www.gnu.org/software/dejagnu/manual/x47.html for
    more details)
 - Fix to show error logs.

ftracetest is a small dash script for testing ftrace features.
It will be required to add a unit test for each new feature
after this is merged, because of preventing feature regressions.

This version still be out of the selftest. However, at the kernel
summit, I talked with Shuah about that. And since the kselftest
will be the standard kernel unit test framework, I agreed to
move this under the selftest. But I also would like to ask Steven
and Namhyung to agree with it before moving.

Actually, since we've already has similar shell-script base
testcase under kselftest, we can easily move this under
selftests.

Thank you,

---

Masami Hiramatsu (4):
      ftracetest: Initial commit for ftracetest
      ftracetest: Add ftrace basic testcases
      ftracetest: Add kprobe basic testcases
      ftracetest: Add XFAIL/XPASS and POSIX.3 std. result codes


 tools/testing/ftrace/README                        |   78 +++++++
 tools/testing/ftrace/ftracetest                    |  217 ++++++++++++++++++++
 tools/testing/ftrace/test.d/basic1.tc              |    7 +
 tools/testing/ftrace/test.d/basic2.tc              |    8 +
 tools/testing/ftrace/test.d/basic3.tc              |    9 +
 .../testing/ftrace/test.d/kprobe/add_and_remove.tc |   12 +
 tools/testing/ftrace/test.d/kprobe/busy_check.tc   |   14 +
 tools/testing/ftrace/test.d/template               |   10 +
 8 files changed, 355 insertions(+)
 create mode 100644 tools/testing/ftrace/README
 create mode 100755 tools/testing/ftrace/ftracetest
 create mode 100644 tools/testing/ftrace/test.d/basic1.tc
 create mode 100644 tools/testing/ftrace/test.d/basic2.tc
 create mode 100644 tools/testing/ftrace/test.d/basic3.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/add_and_remove.tc
 create mode 100644 tools/testing/ftrace/test.d/kprobe/busy_check.tc
 create mode 100644 tools/testing/ftrace/test.d/template

--

