Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936440AbaH1Ikd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:40:33 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47488 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaH1Ik3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:40:29 -0400
Message-ID: <53FEEAF6.1030701@hitachi.com>
Date: Thu, 28 Aug 2014 17:40:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/4] ftracetest: Initial commit for ftracetest
References: <20140826111511.5711.28493.stgit@kbuild-fedora.novalocal> <20140826111518.5711.71441.stgit@kbuild-fedora.novalocal> <20140827155456.GH10937@hercules>
In-Reply-To: <20140827155456.GH10937@hercules>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/28 0:54), Luis Henriques wrote:
> Hi,
> 
> Not really a complete review, but just 2 comments on this script:
> 
> On Tue, Aug 26, 2014 at 11:15:18AM +0000, Masami Hiramatsu wrote:
> ...
>> +prlog() { # messages
>> +  echo $@ | tee -a $LOG_FILE
>> +}
>> +catlog() { #file
>> +  cat $1 | tee -a $LOG_FILE
>> +}
>> +
>> +# Testcase management
>> +PASSED_CASES=
>> +FAILED_CASES=
>> +CASENO=0
>> +testcase() { # testfile
>> +  CASENO=$((CASENO+1))
>> +  prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
>> +}
>> +failed() {
>> +  prlog -e "\t[FAIL]"
>> +  FAILED_CASES="$FAILED_CASES $CASENO"
>> +}
>> +passed() {
>> +  prlog -e "\t[PASS]"
>> +  PASSED_CASES="$PASSED_CASES $CASENO"
>> +}
> 
> What I see here is a '-e' being echo'ed and not really a '-e' switch
> being used to 'echo'.  (Also, I'm not sure if this is a standard
> switch...).
> 
> This applies to all the other 'prlog -e'.

Oh, really? what shell did you use?
My target shell is the busybox and I've tested it on fedora20.

e.g. busybox echo command seems accept -e.
  $ busybox echo -e '\tfoo'
  	foo

Of course maybe I'd better not use \t, but "	"...


>> +
>> +
>> +# Run one test case
>> +run_test() { # testfile
>> +  local testname=`basename $1`
>> +  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
>> +  testcase $1
>> +  echo "execute: "$1 > $testlog
>> +  (cd $TRACING_DIR; set -x ; source $t) >> $testlog 2>&1
>> +  ret=$?
> 
> I believe the usage of 'source' is a bashism, and '.' should be used
> instead.  In my environment, 'source' results in ret=127.  Replacing
> it by '.' fixes it.

Ah, right. I missed that, I'll fix that :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


