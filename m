Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaDKDDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:03:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50463 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaDKDDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:03:23 -0400
Message-ID: <53475B74.30504@hitachi.com>
Date: Fri, 11 Apr 2014 12:03:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com> <5346A8BE.5060401@redhat.com>
In-Reply-To: <5346A8BE.5060401@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/10 23:20), Denys Vlasenko wrote:
> On 04/10/2014 03:57 PM, Masami Hiramatsu wrote:
>> (2014/04/10 22:41), Denys Vlasenko wrote:
>>> On 04/09/2014 05:43 PM, Oleg Nesterov wrote:
>>>> On 04/08, Jim Keniston wrote:
>>>>>
>>>>> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
>>>>>> 0xe8. Anything else?
>>>>>
>>>>> No, I think e8 is the only call instruction uprobes will see.
>>>>
>>>> Good.
>>>
>>> There is this monstrosity, "16-bit override for branches" in 64-mode:
>>>
>>> 66 e8 nn nn       callw   <offset16>
>>>
>>> Nobody sane uses it because it truncates instruction pointer.
>>
>> No problem, insn.c can handle that too. :)
> 
> That's good that we decode it correctly,
> but there is more to it.
> 
> Call insn pushes return address to stack.
> 
> This "mutant 16-bit call", what should it push?
> Full RIP?
> Truncated 16-bit IP? If yes, by how much does it
> advance RSP? +2? +8?
> Hmm. Does it affect RSP or only its 16-bit lower part?

At least, if we can trust Intel SDM, it says that depends
on the operand-size (insn->opnd_bytes) and stack segment
descriptor. Please check the SDM vol.1 6.2.2 Stack Alignment
and vol.2a, 3.2 Instructions (A-M), CALL—Call Procedure.
But we'd better check it on x86-32.

Thank you!

> 
> It's a can of worms! :)


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


