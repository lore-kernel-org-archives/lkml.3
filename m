Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaDQPUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:20:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41606 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDQPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:20:41 -0400
Message-ID: <534FF135.40404@oracle.com>
Date: Thu, 17 Apr 2014 11:20:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, vegard.nossum@oracle.com,
        penberg@kernel.org, jamie.iles@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com> <534E1559.8050904@hitachi.com>
In-Reply-To: <534E1559.8050904@hitachi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 01:30 AM, Masami Hiramatsu wrote:
> (2014/04/16 13:03), Sasha Levin wrote:
>> > On 04/15/2014 11:54 PM, H. Peter Anvin wrote:
>>> >> On 04/15/2014 08:47 PM, Sasha Levin wrote:
>>>>> >>>>
>>>>> >>>> Yes, if kmemcheck for some reason needs to figure out if an instruction
>>>>> >>>> is a MOV variant we'll need to list quite a few mnemonics, but that list
>>>>> >>>> will be much shorter and more readable than a corresponding list of opcodes.
>>>>> >>>>
>>> >> You're completely missing my point.  If you are looking at MOV, with
>>> >> 80%+ probability you're doing something very, very wrong, because you
>>> >> will be including instructions that do something completely different
>>> >> from what you thought.
>>> >>
>>> >> This is true for a lot of the x86 instructions.
>> > 
>> > Right, but assuming that the AND example I presented earlier makes sense, I
>> > can't create mnemonic entries only for instructions where doing so would
>> > "probably" be right.
>> > 
>> > If there are use cases where working with mnemonics is correct, we should
>> > be doing that in kmemcheck. If the way kmemcheck deals with mnemonics is
>> > incorrect we should go ahead and fix kmemcheck.
> In that case, as I said, the mnemonics classifier should be build in
> kmemcheck at this point, since we cannot provide any general mnemonic
> classifier for that purpose. If it becomes enough generic, and accurate,
> it would be better consolidate both, I think.

kmemcheck isn't an instruction decoder, it should not be parsing x86-opcode-map.txt,
that's why there's an API to access that in inat.c.

Basically you're saying that you don't want to extend the API to extract the extra
mnemonic field which already exists in the data we're extracting from anyways, and
that kmemcheck should go around the API and do it itself.

It's not like the instruction decoder is a generic piece of code right now anyways,
it only serves mostly [k,u]probes and was built around the their requirements, and
now everybody are surprised that kmemcheck has different requirements than kprobes.


Thanks,
Sasha
