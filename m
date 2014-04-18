Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaDRPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:48:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51699 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaDRPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:48:07 -0400
Message-ID: <5351491F.3030309@oracle.com>
Date: Fri, 18 Apr 2014 11:47:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com> <534E1559.8050904@hitachi.com> <534FF135.40404@oracle.com> <534FF31E.1000104@zytor.com> <53500FF8.8010804@oracle.com> <53509EB9.5070001@hitachi.com> <53509FD9.2020803@zytor.com>
In-Reply-To: <53509FD9.2020803@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:45 PM, H. Peter Anvin wrote:
>>> The other part is adding mnemonics to the instruction decoder. If my
>>> >> explanation above makes sense, and kmemcheck does need to know about AND,
>>> >> OR, XOR, MOVS and CMPS then let me know how to proceed about changing
>>> >> the instruction decoder to add that functionality.
>> > 
>> > I don't think we need to add such things to instruction decoder.
>> > You'd better start from clarifying the bit pattern of those instructions
>> > and making macros or inlines which evaluate insn->opcode.value.

There are very specific mnemonics that kmemchecks wants to detect and treat
as a corner case.

What you're saying here is that while the instruction decoder already has the
knowledge of mnemonics, kmemcheck shouldn't use it and instead write it's own
opcode -> mnemonic parser and use that instead.

Note that it won't be enough to decode just the opcodes, as variants of the
instructions we need to detect are hidden inside groups, so we'd need to parse
mod/rm in addition to the opcode.

This means we're adding a tiny instruction parser to kmemcheck, which is
exactly the thing we're trying to remove with the previous part of this
patchset.

>> > Using automatic generated macros for immediate in the source code always
>> > leads misunderstanding and abuse, and is hard to fix if a bug is there.
>> > I strongly recommend you to define instruction classification macros
>> > for their use by hand. That's easy to review too.
>> > Actually x86 has a long history and its mnemonics are not so simple...

If the issue is that they get dynamically generated I'm fine with making that
a static list and updating it by hand whenever new instructions or
mnemonics are introduced.

> What it sounds like it really wants is a "bitwise" flag on the instruction.

A flag like that would solve part of the problem (we'd still need to work with
CMPS and MOVS), and sounds very kmemcheck specific.


Thanks,
Sasha
