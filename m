Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935129AbaH0PzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:55:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934964AbaH0PzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:55:11 -0400
Date: Wed, 27 Aug 2014 16:54:56 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/4] ftracetest: Initial commit for ftracetest
Message-ID: <20140827155456.GH10937@hercules>
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal>
 <20140826111518.5711.71441.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826111518.5711.71441.stgit@kbuild-fedora.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not really a complete review, but just 2 comments on this script:

On Tue, Aug 26, 2014 at 11:15:18AM +0000, Masami Hiramatsu wrote:
...
> +prlog() { # messages
> +  echo $@ | tee -a $LOG_FILE
> +}
> +catlog() { #file
> +  cat $1 | tee -a $LOG_FILE
> +}
> +
> +# Testcase management
> +PASSED_CASES=
> +FAILED_CASES=
> +CASENO=0
> +testcase() { # testfile
> +  CASENO=$((CASENO+1))
> +  prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
> +}
> +failed() {
> +  prlog -e "\t[FAIL]"
> +  FAILED_CASES="$FAILED_CASES $CASENO"
> +}
> +passed() {
> +  prlog -e "\t[PASS]"
> +  PASSED_CASES="$PASSED_CASES $CASENO"
> +}

What I see here is a '-e' being echo'ed and not really a '-e' switch
being used to 'echo'.  (Also, I'm not sure if this is a standard
switch...).

This applies to all the other 'prlog -e'.

> +
> +
> +# Run one test case
> +run_test() { # testfile
> +  local testname=`basename $1`
> +  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
> +  testcase $1
> +  echo "execute: "$1 > $testlog
> +  (cd $TRACING_DIR; set -x ; source $t) >> $testlog 2>&1
> +  ret=$?

I believe the usage of 'source' is a bashism, and '.' should be used
instead.  In my environment, 'source' results in ret=127.  Replacing
it by '.' fixes it.

Cheers,
--
Luís
