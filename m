Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3KIJLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 04:11:13 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40486 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3KIJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 04:10:56 -0500
Message-ID: <527DFC1C.1020107@hitachi.com>
Date: Sat, 09 Nov 2013 18:10:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
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
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Subject: Re: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org> <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org> <20131108165639.GD15074@mudshark.cambridge.arm.com>
In-Reply-To: <20131108165639.GD15074@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/09 1:56), Will Deacon wrote:
> Hi Sandeepa,
> 
> On Thu, Oct 17, 2013 at 12:17:47PM +0100, Sandeepa Prabhu wrote:
>> Add support for basic kernel probes(kprobes), jump probes (jprobes)
>> for ARM64.
> 
> I think this series will conflict quite heavily with the jump_label series,
> since they both introduce some common instruction manipulation code. On the
> debug side, there will also be conflicts with the kgdb series, so it might
> make sense for us to merge those two first, then you can rebase on a stable
> branch from us.

[...]

> In fact, how do you avoid a race with hardware breakpoints? E.g., somebody
> places a hardware breakpoint on an instruction in the kernel for which
> kprobes has patched in a brk. We take the hardware breakpoint, disable the
> breakpoint and set up a single step before returning to the brk. The brk
> then traps, but we must take care not to disable single-step and/or unmask
> debug exceptions, because that will cause the hardware breakpoint code to
> re-arm its breakpoint before we've stepped off the brk instruction.

Hmm, frankly to say, this kind of race issue is not seriously discussed
on x86 too, since kgdb is still a special tool (not used on the production
system).
I think under such situation kgdb operator must have full control of the
system, and he can (and has to) avoid such kind of race.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


