Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaHGExe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:53:34 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60936 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaHGExd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:53:33 -0400
Message-ID: <53E30646.6010406@hitachi.com>
Date: Thu, 07 Aug 2014 13:53:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] ftrace: Add a ftrace test collection
References: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal> <20140805173752.1de5f1c2@gandalf.local.home>
In-Reply-To: <20140805173752.1de5f1c2@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/06 6:37), Steven Rostedt wrote:
> Hi Masami,
> 
> This looks great. I'm a bit busy at the moment (just came back from
> vacation, and digging myself out of the hole that left me). But I
> definitely want this in. I have a bunch of tests too, that I can put on
> top of this. My tests are rather hacky, and hard code a lot of stuff in
> them, but they do test a bunch of features of ftrace. It shouldn't be
> too hard to include them here.

Thanks! and I found some ftrace testcases in LTP,

https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/tracing/ftrace_stress_test/ftrace_stress

Most of them are for stress test, but basic ideas are good for
unit test. And IMHO, ftrace unit test should be within the kernel
tree.

> 
> 
> On Tue, 05 Aug 2014 02:45:44 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Hi,
>>
>> I'd like to introduce a collection of testcases for ftrace to
>> avoid regressions.
>>
>> For a long time, we've tried to stabilize and extend ftrace
>> tracing infrastructure. This small test framework is a kind of
>> stabilizing work for ftrace. For the first step, this series
>> just introduces a few basic testcases. However, it is easy to
>> add additional tests. I'd like to ask you, ftrace developers,
>> to add tests for your features to ensure it will not be broken
>> by future works.
>>
>> ftracetest is a tiny bash script so that anyone can easily
>> understand what it does. I think it is better to share and
>> discuss this tests before growing it.
>>
>>  - Is it enough to support bash script? (of course you can
>>    invoke other commands from the script)
>>  - What's the good naming method of testcases?
>>  - Is any dependency check required?
>>
>> BTW, I decided to put this under tools/testing/ftrace instead
>> of tools/testing/selftests/, because all tests requires root
>> privilege. It will be one of discussion points. Anyway,
>> it is easy to integrate this to the selftests.
> 
> I agree. I think having its own directory is a good idea. Lets see what
> other people think.

Actually, current sefltests provides just a space, not minimal
functions, like log management, test statistics, etc. which ftracetest
has. And I doubt that Make-based test framework is good for providing
such functions.
I think it is also another option to generalize the ftracetest script
for selftests :)

> When I get time, I'll see if I can start a branch
> that pulls this in and start adding my own tests on top of it.

I look forward to see your tests :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


