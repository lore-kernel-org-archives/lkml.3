Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3JVDp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 23:45:58 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:50839 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3JVDp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 23:45:57 -0400
Message-ID: <5265F4EB.2060803@linaro.org>
Date: Mon, 21 Oct 2013 23:45:47 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-3-git-send-email-dave.long@linaro.org> <20131019170214.GA8324@redhat.com>
In-Reply-To: <20131019170214.GA8324@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/13 13:02, Oleg Nesterov wrote:
> On 10/15, David Long wrote:
>>
>> @@ -1732,9 +1732,6 @@ static void handle_swbp(struct pt_regs *regs)
>>   		return;
>>   	}
>>
>> -	/* change it in advance for ->handler() and restart */
>> -	instruction_pointer_set(regs, bp_vaddr);
>> -
>
> Well, this looks obviously wrong. This SET_IP() has the comment ;)
>
> Note also that with this breaks __skip_sstep() on x86.
>
> Oleg.
>

Yes, and there's a missing weak stub function in there too.  It was a 
surprise to me that declaring an external as weak means that it quietly 
ignores the fact there is no definition for it at link time, and makes 
it zero.  I think there may be some similar land mines elsewhere in the 
kernel, unrelated to these changes or uprobes in general.

I have an updated version to go out with the v3 patches.  It is working 
with v3.12-rc6 on x86 and ARM, to the extent I'm able to test it.

-dl

