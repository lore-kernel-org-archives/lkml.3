Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbaDIM7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:59:04 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60913 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbaDIM7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:59:01 -0400
Message-ID: <5345440E.10800@hitachi.com>
Date: Wed, 09 Apr 2014 21:58:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops
References: <20140404185131.GA14738@redhat.com> <5343BCF0.3030605@hitachi.com> <20140408161020.GB31460@redhat.com>
In-Reply-To: <20140408161020.GB31460@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/09 1:10), Oleg Nesterov wrote:
> On 04/08, Masami Hiramatsu wrote:
>>
>> (2014/04/05 3:51), Oleg Nesterov wrote:
>>>
>>> TODO: An error from adjust_ret_addr() shouldn't be silently ignored,
>>> we should teach arch_uprobe_post_xol() or handle_singlestep() paths
>>> to restart the probed insn in this case. And probably "adjust" can
>>> be simplified and turned into set_ret_addr(). It seems that we do
>>> not really need copy_from_user(), we can always calculate the value
>>> we need to write into *regs->sp.
>>
>> It seems that you fixed this in 8/9, we don't need the TODO list in
>> the description.
> 
> Well, OK, I'll update the changelog and remove the "error ... ignored"
> part. Although to be honest, I do not understand why do you think it
> is bad to document the other problems you found while you were writing
> the patch.

Because you know how to fix that and you just can do that in following
patches :). In that case, you don't need to state it here.


>>> +	if (auprobe->ops->emulate)
>>> +		return auprobe->ops->emulate(auprobe, regs);
>>> +
>>> +	/* TODO: move this code into ->emulate() hook */
>>
>> If you think this can move into the emulate(),
> 
> Yes sure,
> 
>> you should do in this
>> patch.
> 
> No, sorry, I strongly disagree, this should come as a separate change,
> and only after "Emulate jmp's".

Ah, I see, with your RFC series. :)

>> Since the following code runs by default, there should be
>> no problem to do that.
> 
> Hmm. Not sure I understand "by default".

I meant that the auprobe->ops->emulate() is always skipped and the
old code is always run, since the default_emulate_op() is NULL at
this point.

> If you meant that this should
> go into default_emulate_op() (which we do not have), then I strongly
> disagree again.
> 
> It should not, if nothing else we need to record insn->length somewhere,
> this should go into ttt_emulate_op() we add later. And it simply looks
> much more natural to handle jmp's and nop's together.

I see, OK with ttt_emulate_op() series.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you :)

> 
> Masami, this time I simply can't understand your objections, please
> clarify.
> 
> Thanks,
> 
> Oleg.
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


