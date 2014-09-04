Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaIDC3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:29:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36994 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaIDC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:29:52 -0400
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
Subject: Re: [RFC PATCH v3 4/4] ftracetest: Add XFAIL/XPASS and POSIX.3 std. result codes
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal>
	<20140902110659.3207.67086.stgit@kbuild-f20.novalocal>
Date: Thu, 04 Sep 2014 11:29:50 +0900
In-Reply-To: <20140902110659.3207.67086.stgit@kbuild-f20.novalocal> (Masami
	Hiramatsu's message of "Tue, 02 Sep 2014 11:06:59 +0000")
Message-ID: <87mwag9kyp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014 11:06:59 +0000, Masami Hiramatsu wrote:
> Add XFAIL, XPASS and POSIX 1003.3 std. codes (UNRESOLVED/
> UNTESTED/UNSUPPORTED) as a result code. These are
> used for the results that test case is expected to fail or
> unsupported feature (by config).
> This also introduces PASS/FAIL/XFAIL/XPASS/UNSUP/UNTST/UNRES
> result codes for each testcase. Since the results are not
> binary, each testcase must use these codes to return the
> test result.
>
> Changes in v3:
>  - Add UNRESOLVED/UNTESTED codes.
>  - Fix to handle undefined codes.
>  - Add a document about return codes.
>  - Fix to show failure logs.
>  - Don't use -e option for echo since dash doesn't support it.
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---

[SNIP]
> diff --git a/tools/testing/ftrace/test.d/basic3.tc b/tools/testing/ftrace/test.d/basic3.tc
> index 0c1a3a2..7bc5a53 100644
> --- a/tools/testing/ftrace/test.d/basic3.tc
> +++ b/tools/testing/ftrace/test.d/basic3.tc
> @@ -1,8 +1,9 @@
>  #!/bin/sh
>  # description: Basic trace clock test
> -[ -f trace_clock ] || exit 1
> +[ -f trace_clock ] || exit $FAIL # this is basic feature, must be there
>  for c in `cat trace_clock | tr  -d \[\]`; do
> -  echo $c > trace_clock || exit 1
> -  grep '\['$c'\]' trace_clock || exit 1
> +  echo $c > trace_clock || exit $FAIL
> +  grep '\['$c'\]' trace_clock || exit $FAIL
>  done
> -echo local > trace_clock
> +echo local > trace_clock || exit $FAIL
> +exit $PASS

IMHO it's a bit sad that we need to write every test in this way -
adding '|| exit $FAIL' for every command.  It'd be better if only
exceptional cases require that explicitly and normal cases live in
simple.

Can we do better - like using trap or something?

Thanks,
Namhyung
