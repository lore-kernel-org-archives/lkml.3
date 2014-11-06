Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKFDMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:12:30 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54333 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKFDM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:12:29 -0500
Message-ID: <545AE716.7060101@hitachi.com>
Date: Thu, 06 Nov 2014 12:12:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] ftracetest: Use logfile name supported by busybox's
 mktemp
References: <1415239470-28705-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1415239470-28705-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/06 11:04), Namhyung Kim wrote:
> When I run the ftracetest in a busybox docker container, I saw
> following error.  Make the logfile template to comply with busybox's
> mktemp.  It also keep the logfiles under the logs directory.
> 
>   # /linux/tools/testing/selftests/ftrace/ftracetest
>   === Ftrace unit tests ===
>   mktemp: unrecognized option `--tmpdir=/linux/tools/testing/selftests/ftrace/logs/20141106-003624/'
>   BusyBox v1.22.1 (2014-05-22 23:22:11 UTC) multi-call binary.
> 
>   Usage: mktemp [-dt] [-p DIR] [TEMPLATE]
> 
>   Create a temporary file with name based on TEMPLATE and print its name.
>   TEMPLATE must end with XXXXXX (e.g. [/dir/]nameXXXXXX).
>   Without TEMPLATE, -t tmp.XXXXXX is assumed.
> 
>   	-d	  Make directory, not file
>   	-q	  Fail silently on errors
>   	-t	  Prepend base directory name to TEMPLATE
>   	-p DIR	  Use DIR as a base directory (implies -t)
>   	-u Do not create anything; print a name
> 
>   Base directory is: -p DIR, else $TMPDIR, else /tmp

Oops! good catch :)

> 
>   [1] Basic trace file check/linux/tools/testing/selftests/ftrace/ftracetest: line 244: can't create : nonexistent directory
>   /linux/tools/testing/selftests/ftrace/ftracetest: line 244: can't create : nonexistent directory
> 						  [FAIL]
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,


> ---
>  tools/testing/selftests/ftrace/ftracetest | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
> index 8cc01c14262f..93b1bf5eadb5 100755
> --- a/tools/testing/selftests/ftrace/ftracetest
> +++ b/tools/testing/selftests/ftrace/ftracetest
> @@ -218,7 +218,7 @@ trap 'SIG_RESULT=$XFAIL' $SIG_XFAIL
>  # Run one test case
>  run_test() { # testfile
>    local testname=`basename $1`
> -  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
> +  local testlog=`mktemp $LOG_DIR/${testname}-log.XXXXXX`
>    testcase $1
>    echo "execute: "$1 > $testlog
>    SIG_RESULT=0
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


