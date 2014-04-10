Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613AbaDJOVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934295AbaDJOVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:21:08 -0400
Message-ID: <5346A8BE.5060401@redhat.com>
Date: Thu, 10 Apr 2014 16:20:46 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com>
In-Reply-To: <5346A362.9010802@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 03:57 PM, Masami Hiramatsu wrote:
> (2014/04/10 22:41), Denys Vlasenko wrote:
>> On 04/09/2014 05:43 PM, Oleg Nesterov wrote:
>>> On 04/08, Jim Keniston wrote:
>>>>
>>>> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
>>>>> 0xe8. Anything else?
>>>>
>>>> No, I think e8 is the only call instruction uprobes will see.
>>>
>>> Good.
>>
>> There is this monstrosity, "16-bit override for branches" in 64-mode:
>>
>> 66 e8 nn nn       callw   <offset16>
>>
>> Nobody sane uses it because it truncates instruction pointer.
> 
> No problem, insn.c can handle that too. :)

That's good that we decode it correctly,
but there is more to it.

Call insn pushes return address to stack.

This "mutant 16-bit call", what should it push?
Full RIP?
Truncated 16-bit IP? If yes, by how much does it
advance RSP? +2? +8?
Hmm. Does it affect RSP or only its 16-bit lower part?

It's a can of worms! :)

