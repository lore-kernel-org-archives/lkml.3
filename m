Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3JRDey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 23:34:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24528 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3JRDex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 23:34:53 -0400
Message-ID: <5260AB8A.2060505@huawei.com>
Date: Fri, 18 Oct 2013 11:31:22 +0800
From: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jiang Liu <liuj97@gmail.com>, Will Deacon <will.deacon@arm.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] arm64, jump label: optimize jump label implementation
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com> <1381893492-7135-7-git-send-email-liuj97@gmail.com> <20131016114608.GH5403@mudshark.cambridge.arm.com> <525EC8D1.7000900@gmail.com> <20131017093944.GB18765@mudshark.cambridge.arm.com> <525FF6E0.7070000@gmail.com> <20131017112713.2638910f@gandalf.local.home>
In-Reply-To: <20131017112713.2638910f@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.76.110]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013/10/17 23:27, Steven Rostedt wrote:
> On Thu, 17 Oct 2013 22:40:32 +0800
> Jiang Liu <liuj97@gmail.com> wrote:
>
>
>>>>> You could make the code more concise by limiting your patching ability to
>>>>> branch immediates. Then a nop is simply a branch to the next instruction (I
>>>>> doubt any modern CPUs will choke on this, whereas the architecture requires
>>>>> a NOP to take time).
>>>> I guess a NOP should be more effecient than a "B #4" on real CPUs:)
>>>
>>> Well, I was actually questioning that. A NOP *has* to take time (the
>>> architecture prevents implementations from discaring it) whereas a static,
>>> unconditional branch will likely be discarded early on by CPUs with even
>>> simple branch prediction logic.
>> I naively thought "NOP" is cheaper than a "B" :(
>> Will use a "B #1" to replace "NOP".
>>
>
> Really?? What's the purpose of a NOP then? It seems to me that an
> architecture is broken if a NOP is slower than a static branch.
>
> -- Steve
Hi Steve and Will,
	I have discussed this with one of our chip design members.
He thinks "NOP" should be better than "B #1" because jump instruction
is one of the most complex instructions for microarchitecture, which
may stall the pipeline. And NOP should be friendly enough for all
microarchitectures. So I will keep the "NOP" version.
Thanks!
Gerry


