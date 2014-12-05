Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaLEFIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:08:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52150 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaLEFIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:08:41 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Fri, 5 Dec 2014 14:08:43 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] ftracetest: Add --verbose option for showing echo
 output
Message-ID: <20141205050843.GA18217@sejong>
References: <20141204194109.7376.84279.stgit@localhost.localdomain>
 <20141204194123.7376.22964.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141204194123.7376.22964.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:41:23PM -0500, Masami Hiramatsu wrote:
> Add --verbose/-v option for showing echo output in testcases.
> This is good for checking the progress of testcases which
> take a longer time to run.
> 
> To implement this feature, all the testcase failures are
> captured in ftracetest and send signal to set SIG_RESULT=FAIL.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---

[SNIP]
> -  # setup PID and PPID, $$ is not updated.
> -  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
> -   set -e; set -x; . $1) >> $testlog 2>&1
> -  eval_result $? $SIG_RESULT
> +  if [ $VERBOSE -ne 0 ]; then
> +    __run_test $1 2>> $testlog | tee -a $testlog

Shouldn't it be

       __run_test $1 2>&1 | tee -a $testlog

?

Thanks,
Namhyung


> +  else
> +    __run_test $1 >> $testlog 2>&1
> +  fi
> +  eval_result $SIG_RESULT
>    if [ $? -eq 0 ]; then
>      # Remove test log if the test was done as it was expected.
>      [ $KEEP_LOG -eq 0 ] && rm $testlog
