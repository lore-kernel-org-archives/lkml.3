Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3J3VLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:11:14 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33119 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3J3VLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:11:11 -0400
Message-ID: <527175EB.9000809@linaro.org>
Date: Wed, 30 Oct 2013 17:11:07 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-3-git-send-email-dave.long@linaro.org> <20131019170214.GA8324@redhat.com> <20131028185425.GA12863@redhat.com>
In-Reply-To: <20131028185425.GA12863@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, all this week it's me that's traveling.


On 10/28/13 14:54, Oleg Nesterov wrote:
> David, sorry for delay.
>
> On 10/19, Oleg Nesterov wrote:
>>
>> On 10/15, David Long wrote:
>>>
>>> @@ -1732,9 +1732,6 @@ static void handle_swbp(struct pt_regs *regs)
>>>   		return;
>>>   	}
>>>
>>> -	/* change it in advance for ->handler() and restart */
>>> -	instruction_pointer_set(regs, bp_vaddr);
>>> -
>>
>> Well, this looks obviously wrong. This SET_IP() has the comment ;)
>>
>> Note also that with this breaks __skip_sstep() on x86.
>
> Hmm. Thinking more, it seems that this patch has another problem.
>
> IIUC, the whole point of arch_uprobe_ignore() is to avoid
> handler_chain() if the condition was not satisfied, so you need
> to call it before handler_chain() ?

Yes, you're right.  I can see now that is a bad merge of an earlier 
version of the patch.  I have just tested the fix.  Thanks for finding this.

>
> Otherwise this logic should go into can_skip_sstep() and we simply
> do not need the new hook, just we need to tweak the (ugly)
> UPROBE_SKIP_SSTEP logic.
>
> Oleg.
>


-dl

