Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3KRGzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 01:55:18 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63848 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3KRGzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 01:55:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131115163936.GI19468@mudshark.cambridge.arm.com>
References: <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
	<52808D53.7080904@hitachi.com>
	<5280B6C8.7050807@hitachi.com>
	<20131111105812.GC28302@mudshark.cambridge.arm.com>
	<528114C4.5000506@hitachi.com>
	<CA+b37P08cLAvBYAXSkozLPzrpuXn=N0SUetwL6N8JL+10AtYjQ@mail.gmail.com>
	<5281D848.7000502@hitachi.com>
	<CA+b37P1sNsEXrJFfVL51sZ-SeGNCBiwXnOwCiFY8CBwSXPw+mQ@mail.gmail.com>
	<20131113143110.GF28881@mudshark.cambridge.arm.com>
	<CA+b37P1-DPtSu5vB+_4HamUtDNSFn0qNbPWk9A6+vUAp4tu6_w@mail.gmail.com>
	<20131115163936.GI19468@mudshark.cambridge.arm.com>
Date: Mon, 18 Nov 2013 12:25:05 +0530
Message-ID: <CA+b37P14G=j-y_dCzOC7nbiBwu-oK_dUA-8qXHKr7dZQqnqkMQ@mail.gmail.com>
Subject: Re: Re: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This is generic test module (samples/hw_breakpoint/data_breakpoint.ko)
>> which places watchpoint for bothe read/write.
>> Atleast watchpt should have triggered for Read right? I also tried
>> with othe functions like do_fork, vfs_read etc but no hit.
>
> You'd need to place something for exec if you want to see anything on the
> instruction side. A read by the instruction fetcher does not trigger a read
> watchpoint on ARM.
Hmm, then watchpoint cannot not be placed on text address (instruction
fetch path) right?
(Sorry I did not check debug spec fully for watchpoint/hw breakpoints,
I should do that)

>
>> >> 2.  Placing text breakpoint (modified sample module with attr.bp_type
>> >> = HW_BREAKPOINT_X) upon vfs_symlink, and run "ln -s /dev/null
>> >> /tmp/foo".  This time, breakpoint hit but exception is re-cursing
>> >> infinitely!
>> >
>> > The problem here is that we expect the overflow handler to deal with the
>> > stepping (like GDB does via ptrace). If you don't register a handler, the
>> > kernel will do the step (like you would get if you used perf stat -e
>> > mem:0xNNNN:x).
>> [This test was done on upstream branch, without kprobes patches.]
>> Hmm, then this is expected with test breakpoint right? is this
>> handling to be done by perf and ptrace?
>
> perf stat doesn't register an overflow handler, so the hw_breakpoint
> backend will handle the step. ptrace registers a handler which sends a
> SIGTRAP to the debugger (e.g. gdb), which handles the step manually
> (probably using a PTRACE_SINGLESTEP request).
>
>> I did not see arm64 support in linux/tools/perf/,  there are multiple
>> patches in mailing list though. Are you aware of any version of perf
>> that work with arm64?
>
> The perf tool should work fine on arm64 using mainline. Are you seeing
> problems?
Hmm basically perf is working and I can run tests now.
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
