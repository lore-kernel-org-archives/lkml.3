Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaLEFwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:52:50 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59849 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaLEFws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:52:48 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Fri, 5 Dec 2014 14:52:45 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] ftracetest: Add --verbose option for showing echo
 output
Message-ID: <20141205055245.GB18217@sejong>
References: <20141204194109.7376.84279.stgit@localhost.localdomain>
 <20141204194123.7376.22964.stgit@localhost.localdomain>
 <20141205050843.GA18217@sejong>
 <5481414B.5090805@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5481414B.5090805@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 02:23:23PM +0900, Masami Hiramatsu wrote:
> (2014/12/05 14:08), Namhyung Kim wrote:
> > On Thu, Dec 04, 2014 at 02:41:23PM -0500, Masami Hiramatsu wrote:
> >> Add --verbose/-v option for showing echo output in testcases.
> >> This is good for checking the progress of testcases which
> >> take a longer time to run.
> >>
> >> To implement this feature, all the testcase failures are
> >> captured in ftracetest and send signal to set SIG_RESULT=FAIL.
> >>
> >> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >> ---
> > 
> > [SNIP]
> >> -  # setup PID and PPID, $$ is not updated.
> >> -  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
> >> -   set -e; set -x; . $1) >> $testlog 2>&1
> >> -  eval_result $? $SIG_RESULT
> >> +  if [ $VERBOSE -ne 0 ]; then
> >> +    __run_test $1 2>> $testlog | tee -a $testlog
> > 
> > Shouldn't it be
> > 
> >        __run_test $1 2>&1 | tee -a $testlog
> > 
> > ?
> 
> No, that outputs both stdout and stderr to $testlog and console.
> What I'd like to do above is only stdout to $testlog and console and
> stderr goes only to $testlog. (Note that __run_test set -x which outputs
> every executed command to stderr)

Hmm.. so the actual output of the failing command is not shown on
console even when -v option is given, right?

Anyway I worried about that the order of messages might be mixed..

  echo msg1 > /dev/stdout
  echo msg2 > /dev/stderr
  echo msg3 > /dev/stdout
  echo msg4 > /dev/stderr

So the output in this case can be like msg2, msg4, msg1, and msg3..?

Thanks,
Namhyung
