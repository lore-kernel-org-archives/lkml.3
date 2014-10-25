Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaJYABD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 20:01:03 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:53754 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaJYABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 20:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <544AB462.9070708@zytor.com>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
 <54494B74.2080504@amacapital.net> <1414091732.2363.11.camel@redhat.com>
 <CALCETrWQNuGr=Sf7X4E6ZkJQ+diJao30=CeH4xd0T855TgX+rg@mail.gmail.com>
 <1414092624.2363.13.camel@redhat.com> <1414093104.2363.14.camel@redhat.com> <544AB462.9070708@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Oct 2014 17:00:38 -0700
Message-ID: <CALCETrVhqzurg=DF4PV+zv3d4z7nNxgsWgyXJm5kUG1bB75MjQ@mail.gmail.com>
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 1:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/23/2014 12:38 PM, Eric Paris wrote:
>>>
>>> After the call __audit_syscall_entry aren't they already polluted?
>>> Isn't that the reason we need to reload EAX?
>>
>> Well, I guess EAX is special...
>>
>
> Because system calls are "asmlinkage", all the parameters are on the
> stack, but %eax is used as the index into the system call table.  This
> should thus be fine until we get rid of regparm(0) entirely, if that
> ever happens.
>

...and because __audit_syscall_entry *isn't* asmlinkage, it uses the
other convention, which is where the confusion comes from.  And, by
the time you get to sysenter_do_call, nothing cares about ecx, so you
can freely clobber it while popping from the stack.  I get it now.

--Andy

>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
