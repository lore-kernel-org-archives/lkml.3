Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822Ab3FSXTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:19:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:19:31 -0400
Message-ID: <51C23C7E.8000400@redhat.com>
Date: Thu, 20 Jun 2013 01:19:26 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] ptrace: make PTRACE_DETACH work on non-stopped tracees.
References: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com> <20130619163234.GA12029@redhat.com>
In-Reply-To: <20130619163234.GA12029@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 06:32 PM, Oleg Nesterov wrote:
> On 06/19, Denys Vlasenko wrote:
>>
>> This is a user-visible behavior change.
>> Do we really have to introduce a separate
>> PTRACE_NOT_STUPID_DETACH? I hope not.
> 
> Oh, I think yes.
> 
>> @@ -1062,7 +1060,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
>>  	}
>>
>>  	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
>> -				  request == PTRACE_INTERRUPT);
>> +				  request == PTRACE_INTERRUPT ||
>> +				  request == PTRACE_DETACH);
> 
> There doesn't look right.
> 
> For example ptrace_disable(). See the comment set_task_blockstep().

I see the comment. I think it implies that TF-induced debug
interrupt may happen on the running task after it is detached,
which will result in SIGTRAP being sent to it.
Correct me if I'm wrong.

If so, do we have the same problem if tracer exits
and implicit detach is performed?

-- 
vda

