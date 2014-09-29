Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaI2ToN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:44:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbaI2ToM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:44:12 -0400
Message-ID: <5429B664.4060003@zytor.com>
Date: Mon, 29 Sep 2014 12:43:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
CC: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de> <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com> <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 12:41 PM, Thomas Gleixner wrote:
>>
>> If it weren't the case, then we'd be totally screwed.  Fortunately, it
>> is.  I found it: SDM Volume 3 6.12.1.2 says:
>>
>> (On calls to exception and interrupt
>> handlers, the processor also clears the VM, RF, and NT flags in the
>> EFLAGS register,
>> after they are saved on the stack.)
> 
> Sorry, I misunderstood your question.
> 
> And yes on exception and interrupt entry it is cleared. Otherwise the
> whole feature would not work at all ...
> 
> But that's why I'm really not worried about it. While we can mask out
> the stupid bit easily, it does not provide any value except protecting
> silly userspace from rightfully raised exceptions.
> 
> When I first saw that patch, I was worried about the security impact,
> but after staring long enough at the SDM and the code, the only way it
> can explode is when returning to user space. It cannot explode in the
> kernel.
> 
> So in IA-32e it creates a #GP otherwise it falls over the return to
> NULL (TSS.back_link). So what?
> 

How about "it's a bug, but it's not (necessarily) a security issue?"

I think we should mask the bit anyway.

	-hpa


