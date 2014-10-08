Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaJHB75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:59:57 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46879 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHB7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:59:55 -0400
Message-ID: <54349A95.6040309@hitachi.com>
Date: Wed, 08 Oct 2014 10:59:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH ftrace/for-next ] tracing/kprobes: Replace startup
 test with selftest script
References: <20141006114806.2573.63966.stgit@kbuild-f20.novalocal> <20141006183349.60998821@gandalf.local.home> <5433817C.3000206@hitachi.com> <20141007120530.136312fd@gandalf.local.home>
In-Reply-To: <20141007120530.136312fd@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/08 1:05), Steven Rostedt wrote:
> On Tue, 07 Oct 2014 15:00:28 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2014/10/07 7:33), Steven Rostedt wrote:
>>> On Mon, 06 Oct 2014 11:48:06 +0000
>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>> Replace the kprobe_tracer's startup test with two selftest scripts.
>>>> These test cases are testing that the kprobe_event can accept a
>>>> kprobe event with $stack related arguments and a kretprobe event
>>>> with $retval argument.
>>>
>>> Can't we keep both? I have boxes I run my own tests with and enables
>>> these start up tests in the kernel. I don't plan on testing on all
>>> theses boxes using the scripts in the kernel.
>>>
>>> Having a self test in the kernel itself can be useful too.
>>
>> Hmm, deprecating the test is acceptable, but I think it is just
>> a dead weight that if we have both of them forever in the kernel.
>> Of course, if that feature is fundamentally related to booting up
>> the kernel, we need to keep them in boot up code. But if it is
>> possible to run after booting up, I think we'd better to move it
>> under kselftest, since we can do more investigation after booting.
>>
> 
> I'm just saying that it is more likely to have this test run if it's in
> the kernel than in userspace. But as you say, we can debug it better if
> there's a userspace tool that can run too. This is why I'm saying we
> should keep both. I think they are both useful for different reasons.
> Keeping it in the kernel as a config option will give it more exposure,
> and keeping it in the tools/testing directory gives us a way to debug
> it if there an issue should arise.

OK, I can keep both in the kernel at this point. I just expected when we
have kselftest which becomes good enough and widely used, then it is more
likely to be run than the startup selftest, because the startup selftest
requires kernel configuration but kselftest is completely add-on test
(so that we can run it on distro kernel too :)
However, yes, it is just my guess.

> Both of these have valid reasons staying in the kernel and I don't see
> either as dead weight. Is there a maintenance issue with keeping it in
> the kernel? There doesn't seem to be much done to it. It seems
> untouched for over a year, and that was to add support for multiple
> buffers.

Keeping it has no issue. But it's much easier to expand the test
in userspace than the kernel code. I'll add more feature tests in
kselftest, but not in this code. This means that this startup
test code will get behind.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


