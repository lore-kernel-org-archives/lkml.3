Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbbAEUZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:25:43 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51350 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbbAEUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:25:41 -0500
MIME-Version: 1.0
In-Reply-To: <54A300D0.7090802@gmail.com>
References: <54A29722.1010901@gmail.com>
	<CAGXu5j+C0SWQ+CeOb2ADXdsLWorUHahX4UhUg+UGbT6UuWiQFQ@mail.gmail.com>
	<54A300D0.7090802@gmail.com>
Date: Mon, 5 Jan 2015 12:25:40 -0800
X-Google-Sender-Auth: I4MWi2ptg1Pn4pf4KKiX1Bv19Io
Message-ID: <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com>
Subject: Re: Edited seccomp.2 man page for review [v2]
From: Kees Cook <keescook@chromium.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 11:45 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
>>> The program counter will be as though the system call happened
>>> (i.e., it will not point to the system call instruction).
>>> The return value register will contain an architecture\-dependent value;
>>> if resuming execution, set it to something sensible.
>>> .\" FIXME Regarding the preceding line, can you give an example(s)
>>> .\"       of "something sensible"? (Depending on the answer, maybe it
>>> .\"       might be useful to add some text on this point.)
>>
>> This means sensible in the context of the syscall made, or the desired
>> behavior. For example, setting the return value to ELOOP for something
>> like a "bind" syscall isn't very sensible.
>
> Okay -- I did s/sensible/appropriate for the system call/

Yes, perfect. That captures it nicely.

>>> .\"
>>> .\" FIXME Please check:
>>> .\"     In an attempt to make the text clearer, I changed
>>> .\"     "replacing it with" to "setting the return value register to"
>>> .\"     Okay?
>>> (The architecture dependency is because setting the return value register to
>>> .BR ENOSYS
>>> could overwrite some useful information.)
>>
>> Well, the arch dependency is really because _how_ to change the
>> register, and the register itself, is different between architectures.
>> (i.e. which ptrace call is needed, and which register is being
>> changed.) The overwriting of useful information is certainly true too,
>> though.
>
> So, revert to the previous wording? Or do you have a suggested
> better wording?

I think the previous wording is better. I'm struggling to produce
language that makes more sense here.

> Thanks. We're getting close now.

Excellent! :)

-Kees

-- 
Kees Cook
Chrome OS Security
