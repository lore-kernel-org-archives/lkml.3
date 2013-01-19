Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3ASOK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 09:10:26 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:36799 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3ASOKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 09:10:24 -0500
Message-ID: <50FAA942.2050507@synopsys.com>
Date: Sat, 19 Jan 2013 19:40:10 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [PATCH v2 19/76] ARC: Signal handling
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-20-git-send-email-vgupta@synopsys.com> <20130119032357.GB23552@ZenIV.linux.org.uk>
In-Reply-To: <20130119032357.GB23552@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2013 08:53 AM, Al Viro wrote:
> On Fri, Jan 18, 2013 at 05:54:33PM +0530, Vineet Gupta wrote:
>> +SYSCALL_DEFINE0(rt_sigreturn)
>> +{
>> +	struct rt_sigframe __user *sf;
>> +	unsigned int magic;
>> +	int err;
>> +	struct pt_regs *regs = task_pt_regs(current);
> ITYM current_pt_regs()...

Done.

>
>> +	if (unlikely(is_do_ss_needed(magic)))
>> +		if (do_sigaltstack(&sf->uc.uc_stack, NULL, regs->sp) == -EFAULT)
> 	if (!restore_altstack(&sf->uc.uc_stack))
> please...
>
>> +		stk.ss_sp = (void __user *)current->sas_ss_sp;
>> +		stk.ss_flags = sas_ss_flags(regs->sp);
>> +		stk.ss_size = current->sas_ss_size;
>> +		err |= __copy_to_user(&sf->uc.uc_stack, &stk, sizeof(stk));
> that would be
>                 err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
>

Actually altstack consolidation tracking changes are already present in patch
41/76 - which has other 3.8 specific bits too. This is more of a reflection of my
3.7 baseline and a subsequent migration to 3.8. But you are right, it is creating
undue confusion - I'll chop-n-dice-n-squash those bits into appropriate patches.

Thx,
-Vineet
