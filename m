Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaDPFaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:30:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50697 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaDPFaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:30:09 -0400
Message-ID: <534E1559.8050904@hitachi.com>
Date: Wed, 16 Apr 2014 14:30:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vegard.nossum@oracle.com,
        penberg@kernel.org, jamie.iles@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org
Subject: Re: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com>
In-Reply-To: <534E0124.70700@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/16 13:03), Sasha Levin wrote:
> On 04/15/2014 11:54 PM, H. Peter Anvin wrote:
>> On 04/15/2014 08:47 PM, Sasha Levin wrote:
>>>>
>>>> Yes, if kmemcheck for some reason needs to figure out if an instruction
>>>> is a MOV variant we'll need to list quite a few mnemonics, but that list
>>>> will be much shorter and more readable than a corresponding list of opcodes.
>>>>
>> You're completely missing my point.  If you are looking at MOV, with
>> 80%+ probability you're doing something very, very wrong, because you
>> will be including instructions that do something completely different
>> from what you thought.
>>
>> This is true for a lot of the x86 instructions.
> 
> Right, but assuming that the AND example I presented earlier makes sense, I
> can't create mnemonic entries only for instructions where doing so would
> "probably" be right.
> 
> If there are use cases where working with mnemonics is correct, we should
> be doing that in kmemcheck. If the way kmemcheck deals with mnemonics is
> incorrect we should go ahead and fix kmemcheck.

In that case, as I said, the mnemonics classifier should be build in
kmemcheck at this point, since we cannot provide any general mnemonic
classifier for that purpose. If it becomes enough generic, and accurate,
it would be better consolidate both, I think.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


