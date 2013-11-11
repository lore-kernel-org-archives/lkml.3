Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3KKHzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:55:07 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36455 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3KKHzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:55:02 -0500
Message-ID: <52808D53.7080904@hitachi.com>
Date: Mon, 11 Nov 2013 16:54:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
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
Subject: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org> <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org> <20131108165639.GD15074@mudshark.cambridge.arm.com> <527DFC1C.1020107@hitachi.com> <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
In-Reply-To: <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/11 14:39), Sandeepa Prabhu wrote:
> On 9 November 2013 14:40, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> (2013/11/09 1:56), Will Deacon wrote:
>>> Hi Sandeepa,
>>>
>>> On Thu, Oct 17, 2013 at 12:17:47PM +0100, Sandeepa Prabhu wrote:
>>>> Add support for basic kernel probes(kprobes), jump probes (jprobes)
>>>> for ARM64.
>>>
>>> I think this series will conflict quite heavily with the jump_label series,
>>> since they both introduce some common instruction manipulation code. On the
>>> debug side, there will also be conflicts with the kgdb series, so it might
>>> make sense for us to merge those two first, then you can rebase on a stable
>>> branch from us.
>>
>> [...]
>>
>>> In fact, how do you avoid a race with hardware breakpoints? E.g., somebody
>>> places a hardware breakpoint on an instruction in the kernel for which
>>> kprobes has patched in a brk. We take the hardware breakpoint, disable the
>>> breakpoint and set up a single step before returning to the brk. The brk
>>> then traps, but we must take care not to disable single-step and/or unmask
>>> debug exceptions, because that will cause the hardware breakpoint code to
>>> re-arm its breakpoint before we've stepped off the brk instruction.
>>
>> Hmm, frankly to say, this kind of race issue is not seriously discussed
>> on x86 too, since kgdb is still a special tool (not used on the production
>> system).
>> I think under such situation kgdb operator must have full control of the
>> system, and he can (and has to) avoid such kind of race.
> Masami,
> 
> Hmm I think in same lines, but not sure if we expect kprobes to be
> able to work fool-proof along with kgdb or hw breakpoints ?

For hw breakpoint, yes, we finally get check each other to safely
use it even if one rejects the other one at some points(address).
Since the hw breakpoint is already open for normal user via perf,
we should do it. But the policy still needs to be discussed.

On the other hand, kgdb is a special case and it should be,
because, IMHO, kgdb is a debugger, which means that the kgdb
has to be able to monitor whole the kernel from outside. So
kprobes should not change its behavior even if used with kgdb.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


