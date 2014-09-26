Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaIZLzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:55:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35716 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaIZLzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:55:05 -0400
Message-ID: <54255411.4090508@hitachi.com>
Date: Fri, 26 Sep 2014 20:54:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Shuah Khan <shuahkh@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home> <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home> <20140924115811.6eeeab8c@gandalf.local.home> <5422EAE2.6080005@osg.samsung.com> <20140924120853.0a717b7e@gandalf.local.home> <877g0qkj9g.fsf@sejong.aot.lge.com>
In-Reply-To: <877g0qkj9g.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/26 15:06), Namhyung Kim wrote:
> Hi Steve,
> 
> On Wed, 24 Sep 2014 12:08:53 -0400, Steven Rostedt wrote:
>> On Wed, 24 Sep 2014 10:01:38 -0600
>> Shuah Khan <shuahkh@osg.samsung.com> wrote:
>>
>>> I am working on adding the framework for c tests. We will have
>>> to get this evolved for shell scripts. Please see the following
>>> thread:
>>>
>>> https://lkml.org/lkml/2014/9/23/926
>>>
>>
>> Thanks,
>>
>> Also, what's the rules for a test that requires other tools. Some of my
>> tests require trace-cmd to be installed as well as perf. My stress test
>> runs perf against trace-cmd running hackbench (another required tool),
>> but I believe that perf has hackbench built in so I could replace
>> hackbench with the perf version.
> 
> Yeah, and I think we can at least build perf (if not found) for test as
> we can always have the source.  The trace-cmd is different and it'd be
> another reason I need to work on 'perf ftrace' command soon.  ;-)

+1 :)

For the kselftest, we can only expect to have tools in kernel tree (which
should be static-linked) and busybox, so that we can use qemu emulator to
run kselftest on other archs. I guess perf still need some shared
objects to run. That should be solved too.

Anyway, at first we'd better add simpler tests which is not relay on
other tools except busybox shell.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


