Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3KBDdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 23:33:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51194 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3KBDdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 23:33:42 -0400
Message-ID: <52747280.7040708@linaro.org>
Date: Fri, 01 Nov 2013 23:33:20 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/13] uprobes: add arch write opcode hook
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-6-git-send-email-dave.long@linaro.org> <20131019165051.GC7837@redhat.com> <5268137F.3030809@linaro.org> <20131028194914.GA15103@redhat.com> <20131029195920.GA4538@redhat.com>
In-Reply-To: <20131029195920.GA4538@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 15:59, Oleg Nesterov wrote:
> On 10/28, Oleg Nesterov wrote:
>>
>> Yes, yes, sorry for confusion. What I actually tried to suggest is
>> something like the trivial patch below.
>>
>> Then arm can do:
>>
>> 	uprobe_opcode_t arch_uprobe_swbp_insn(struct arch_uprobe *auprobe)
>> 	{
>> 		return __opcode_to_mem_arm(auprobe->bpinsn);
>> 	}
>>
>> No?
>>
>>> I notice there don't seem to be any alternative set_swbp functions
>>> in the (rc6) kernel tree
>>
>> Yes... I think we should simply make it "static". And set_orig_insn()
>> too.
>
> Or. arm can actually reimplement set_swbp(). This doesn't mean the
> duplication of write_opcode() code, we can simply export this helper.
>

That actually looks to me like the cleanest approach.  I have changed 
the static write_opcode() to a global uprobe_write_opcode(), and now 
call it from an arm set_swbp().

Please do *not* make set_swbp() (and set_orig_insn()) static's.  It 
looks like we now have a use for at least one of them.

Thanks,
-dl

