Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbbAGLxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:53:38 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:59667 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbbAGLxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:53:36 -0500
Message-ID: <54AD1E37.8020509@gmail.com>
Date: Wed, 07 Jan 2015 12:53:27 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: mtk.manpages@gmail.com, Daniel Borkmann <dborkman@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Subject: Re: Edited seccomp.2 man page for review [v2]
References: <54A29722.1010901@gmail.com>	<CAGXu5j+C0SWQ+CeOb2ADXdsLWorUHahX4UhUg+UGbT6UuWiQFQ@mail.gmail.com>	<54A300D0.7090802@gmail.com> <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com>
In-Reply-To: <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On 01/05/2015 09:25 PM, Kees Cook wrote:
> On Tue, Dec 30, 2014 at 11:45 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>>>> The program counter will be as though the system call happened
>>>> (i.e., it will not point to the system call instruction).
>>>> The return value register will contain an architecture\-dependent value;
>>>> if resuming execution, set it to something sensible.
>>>> .\" FIXME Regarding the preceding line, can you give an example(s)
>>>> .\"       of "something sensible"? (Depending on the answer, maybe it
>>>> .\"       might be useful to add some text on this point.)
>>>
>>> This means sensible in the context of the syscall made, or the desired
>>> behavior. For example, setting the return value to ELOOP for something
>>> like a "bind" syscall isn't very sensible.
>>
>> Okay -- I did s/sensible/appropriate for the system call/
> 
> Yes, perfect. That captures it nicely.

Okay.

>>>> .\"
>>>> .\" FIXME Please check:
>>>> .\"     In an attempt to make the text clearer, I changed
>>>> .\"     "replacing it with" to "setting the return value register to"
>>>> .\"     Okay?
>>>> (The architecture dependency is because setting the return value register to
>>>> .BR ENOSYS
>>>> could overwrite some useful information.)
>>>
>>> Well, the arch dependency is really because _how_ to change the
>>> register, and the register itself, is different between architectures.
>>> (i.e. which ptrace call is needed, and which register is being
>>> changed.) The overwriting of useful information is certainly true too,
>>> though.
>>
>> So, revert to the previous wording? Or do you have a suggested
>> better wording?
> 
> I think the previous wording is better. I'm struggling to produce
> language that makes more sense here.

Okay -- reverted.

>> Thanks. We're getting close now.
> 
> Excellent! :)

Still hoping to hear from Will Drewy regarding this FIXME in the 
page source:

.\" FIXME What is the significance of the line
.\"           ftest->code = BPF_LDX | BPF_W | BPF_ABS;
.\"       in kernel/seccomp.c::seccomp_check_filter()?

Do you know if he's about?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
