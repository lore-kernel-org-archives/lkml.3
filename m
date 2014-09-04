Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaIDBl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:41:56 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60228 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaIDBlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:41:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/4] ftracetest: Initial commit for ftracetest
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
	<20140902110639.3207.38388.stgit@kbuild-f20.novalocal>
Date: Thu, 04 Sep 2014 10:41:53 +0900
In-Reply-To: <20140902110639.3207.38388.stgit@kbuild-f20.novalocal> (Masami
	Hiramatsu's message of "Tue, 02 Sep 2014 11:06:39 +0000")
Message-ID: <87r3zs9n6m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

Just a nit..


On Tue, 02 Sep 2014 11:06:39 +0000, Masami Hiramatsu wrote:
> ftracetest is a collection of testcase shell-scripts for ftrace.
> To avoid regressions of ftrace, these testcases check correct
> ftrace behaviors. If someone would like to add any features on
> ftrace, the patch series should have at least one testcase for
> checking the new behavior.


[SNIP]
> +# Run one test case
> +run_test() { # testfile
> +  local testname=`basename $1`
> +  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
> +  testcase $1
> +  echo "execute: "$1 > $testlog
> +  (cd $TRACING_DIR; set -x ; . $t) >> $testlog 2>&1

s/$t/$1/ ?

Thanks,
Namhyung


> +  ret=$?
> +  if [ $ret -ne 0 ]; then
> +    failed
> +    catlog $testlog
> +  else
> +    passed
> +    [ $KEEP_LOG -eq 0 ] && rm $testlog
> +  fi
> +}
> +
> +# Main loop
> +for t in $TEST_CASES; do
> +  run_test $t
> +done
> +prlog ""
> +prlog "# of passed: " `echo $PASSED_CASES | wc -w`
> +prlog "# of failed: " `echo $FAILED_CASES | wc -w`
> +
> +test -z "$FAILED_CASES" # if no error, return 0
> diff --git a/tools/testing/ftrace/test.d/template b/tools/testing/ftrace/test.d/template
> new file mode 100644
> index 0000000..ce5f735
> --- /dev/null
> +++ b/tools/testing/ftrace/test.d/template
> @@ -0,0 +1,4 @@
> +#!/bin/sh
> +# description: %HERE DESCRIBE WHAT THIS DOES%
> +# you have to add ".tc" extention for your testcase file
> +exit 0 # Return 0 if the test is passed, otherwise return !0
