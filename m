Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaIQFkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 01:40:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55021 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaIQFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 01:40:36 -0400
Message-ID: <54191ECC.90006@hitachi.com>
Date: Wed, 17 Sep 2014 14:40:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/4] ftracetest: Initial commit for ftracetest
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal> <20140902110639.3207.38388.stgit@kbuild-f20.novalocal> <20140916182109.4fff4169@gandalf.local.home>
In-Reply-To: <20140916182109.4fff4169@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Thank you for your comments.

(2014/09/17 7:21), Steven Rostedt wrote:
>  
>> diff --git a/tools/testing/ftrace/README b/tools/testing/ftrace/README
>> new file mode 100644
>> index 0000000..5d5de16
>> --- /dev/null
>> +++ b/tools/testing/ftrace/README
>> @@ -0,0 +1,45 @@
>> +Linux Ftrace Testcases
>> +
>> +This is a collection of testcases for ftrace tracing feature in the Linux
>> +kernel. Since ftrace exports interfaces via the debugfs, we just need
>> +shell scripts for testing. Feel free to add new test cases.
>> +
>> +Running the ftrace testcases
>> +============================
>> +
>> +At first, you need to be the root user to run this script.
>> +To run all testcases:
>> +
>> +  $ sudo ./ftracetest
>> +
>> +To run specific testcases:
>> +
>> +  # ./ftracetest test.d/basic3.tc
>> +
>> +Or you can also run testcases under given directory:
>> +
>> +  # ./ftracetest test.d/kprobe/
>> +
>> +Contributing new testcases
>> +==========================
>> +
>> +Copy test.d/template to your testcase (whose filename must has *.tc extension)
> 
> "whose filename must have *.tc extension"
> 
>> +and rewrite test description line.
> 
> "and rewrite the test description line"

Thanks, I'll update it.

> 
>> +
>> + * The working directory of the script is <debugfs>/tracing/.
>> +
>> + * Take care about the side effect, because that is run with root privilege.
> 
>  "Take care with side effects as the tests are run with root privilege"
> 
>> +
>> + * Don't take too long. It's a kind of unit test.
> 
>  "The tests should not run for a long period of time. These are to be
>  unit tests"
> 
> We should probably specify what the time should be. Is 20 minutes too
> long?

I guess more than 1 minute is enough long to doubt something
goes wrong. What unit test could be so long?
I think we need something like progress bar for such long tests.

>> +
>> + * You can add a directory for your testcases under test.d/ if needed.
>> +
>> + * The test cases should run on dash (busybox shell) for testing on
>> +   minimal cross-build environments.
>> +
>> +TODO
>> +====
>> +
>> + * Fancy colored output :)
>> +
>> + * Integrate with selftest?
>> diff --git a/tools/testing/ftrace/ftracetest b/tools/testing/ftrace/ftracetest
>> new file mode 100755
>> index 0000000..8d92e74
>> --- /dev/null
>> +++ b/tools/testing/ftrace/ftracetest
>> @@ -0,0 +1,152 @@
>> +#!/bin/sh
>> +# ftracetest - Ftrace test shell scripts
>> +# Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Maybe add your copyright here, with year?

Ah, right.

> 
> Also, we should probably state that this is under the GPL v2?

OK, I'll add it. :)

Thank you,


> 
> -- Steve
> 
>> +
>> +usage() { # errno [message]
>> +[ "$2" ] && echo $2
>> +echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
>> +echo " Options:"
>> +echo "		-h|--help  Show help message"
>> +echo "		-k|--keep  Keep passed test logs"
>> +echo "		-d|--debug Debug mode (trace all shell commands)"
>> +exit $1
>> +}
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


