Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaDRDkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:40:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42257 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaDRDku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:40:50 -0400
Message-ID: <53509EB9.5070001@hitachi.com>
Date: Fri, 18 Apr 2014 12:40:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vegard.nossum@oracle.com,
        penberg@kernel.org, jamie.iles@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com> <534E1559.8050904@hitachi.com> <534FF135.40404@oracle.com> <534FF31E.1000104@zytor.com> <53500FF8.8010804@oracle.com>
In-Reply-To: <53500FF8.8010804@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/18 2:31), Sasha Levin wrote:
>> I also have seen several attempts at using the generic instruction
>> decoder which has resulted in more complexity, not less, because of
>> excess generality, so it is not an obvious thing.
> 
> Let's split this patchset into two:
> 
> We have one part which moves kmemcheck to the generic instruction decoder
> and adds memory access size to the instruction decoder. There seems to be
> no objection to that part beyond technical issues regarding how we store
> the new size value.

This looks OK to me.

> The other part is adding mnemonics to the instruction decoder. If my
> explanation above makes sense, and kmemcheck does need to know about AND,
> OR, XOR, MOVS and CMPS then let me know how to proceed about changing
> the instruction decoder to add that functionality.

I don't think we need to add such things to instruction decoder.
You'd better start from clarifying the bit pattern of those instructions
and making macros or inlines which evaluate insn->opcode.value.

Using automatic generated macros for immediate in the source code always
leads misunderstanding and abuse, and is hard to fix if a bug is there.
I strongly recommend you to define instruction classification macros
for their use by hand. That's easy to review too.
Actually x86 has a long history and its mnemonics are not so simple...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


