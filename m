Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaIALYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:24:07 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36382 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIALYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:24:05 -0400
Message-ID: <5404574E.1070207@hitachi.com>
Date: Mon, 01 Sep 2014 20:23:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/4] ftracetest: Add XFAIL/XPASS/UNSUPPORTED as
 result code
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal> <20140826111539.5711.93588.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140826111539.5711.93588.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/26 20:15), Masami Hiramatsu wrote:
> @@ -132,11 +163,9 @@ run_test() { # testfile
>    echo "execute: "$1 > $testlog
>    (cd $TRACING_DIR; set -x ; source $t) >> $testlog 2>&1
>    ret=$?
> -  if [ $ret -ne 0 ]; then
> -    failed
> -    catlog $testlog
> -  else
> -    passed
> +  eval_result $ret $testlog
> +  if [ $? -eq 0 ]; then
> +    # Remove test log if the test was done as it was expected.
>      [ $KEEP_LOG -eq 0 ] && rm $testlog
>    fi

Oops, I missed to print out the logs for failed tests here.
It should be output.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


