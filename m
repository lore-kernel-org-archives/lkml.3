Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaJXUUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:20:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47714 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaJXUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:20:03 -0400
Message-ID: <544AB462.9070708@zytor.com>
Date: Fri, 24 Oct 2014 13:19:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Andy Lutomirski <luto@amacapital.net>
CC: Richard Guy Briggs <rgb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>	 <54494B74.2080504@amacapital.net> <1414091732.2363.11.camel@redhat.com>	 <CALCETrWQNuGr=Sf7X4E6ZkJQ+diJao30=CeH4xd0T855TgX+rg@mail.gmail.com>	 <1414092624.2363.13.camel@redhat.com> <1414093104.2363.14.camel@redhat.com>
In-Reply-To: <1414093104.2363.14.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 12:38 PM, Eric Paris wrote:
>>
>> After the call __audit_syscall_entry aren't they already polluted?
>> Isn't that the reason we need to reload EAX?
> 
> Well, I guess EAX is special...
> 

Because system calls are "asmlinkage", all the parameters are on the
stack, but %eax is used as the index into the system call table.  This
should thus be fine until we get rid of regparm(0) entirely, if that
ever happens.

	-hpa


