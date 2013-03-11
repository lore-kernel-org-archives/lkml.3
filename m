Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3CKVdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:33:21 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43060 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3CKVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:33:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130311142218.272033794123531b119ca68e@linux-foundation.org>
References: <20130311202255.942745A4121@corp2gmr1-2.hot.corp.google.com>
	<CAGXu5jLcP1-6NpoSqi1kS+ShKwpTUkpLv6BsW6w39cpt9vKSxA@mail.gmail.com>
	<20130311140130.7effd02d12236dff081646d5@linux-foundation.org>
	<CAGXu5jLJwzxRtoU8A_gVbsPLdU6fyXZyBsr0EPxC9ngEhmDC0w@mail.gmail.com>
	<20130311142218.272033794123531b119ca68e@linux-foundation.org>
Date: Mon, 11 Mar 2013 14:33:18 -0700
X-Google-Sender-Auth: 78e8vcH817n1nZSnzlQxoRbTm6A
Message-ID: <CAGXu5jLxwKUT6hYij-u1BP3kPqq-h3p-JKUaGK_J8WWhOvYVsQ@mail.gmail.com>
Subject: Re: + signal-always-clear-sa_restorer-on-execve.patch added to -mm tree
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, Julien Tinnes <jln@google.com>,
        PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 2:22 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 11 Mar 2013 14:03:20 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Mar 11, 2013 at 2:01 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Mon, 11 Mar 2013 13:37:53 -0700 Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> ...
>> >>
>> >
>> > (pop toasting undone)
>> >
>> >> > Subject: signal: always clear sa_restorer on execve
>> >> >
>> >> > When the new signal handlers are set up, the location of sa_restorer is
>> >> > not cleared, leaking a parent process's address space location to
>> >> > children.  This allows for a potential bypass of the parent's ASLR by
>> >> > examining the sa_restorer value returned when calling sigaction().
>> >> >
>> >> > Based on what should be considered "secret" about addresses, it only
>> >> > matters across the exec not the fork (since the VMAs haven't changed until
>> >> > the exec).  But since exec sets SIG_DFL and keeps sa_restorer, this is
>> >> > where it should be fixed.
>> >>
>> >> A note for backporters: you'll likely want to change
>> >> __ARCH_HAS_SA_RESTORER to SA_RESTORER, since the former was recently
>> >> introduced. If not, this will apply but not actually do any good.
>> >
>> > I added this to the changelog, but I fear people won't read it!  Is
>> > there any clever way in which we can have one patch which will work OK
>> > in both old and new kernels?  I can't think of one...
>>
>> Using just SA_RESTORER will work in both cases, but isn't "correct"
>> going forward. :(
>
> That's easy.
>
> patch #1: use SA_RESTORER, cc stable (please promise me this will work OK)

I don't have the ability to build all the architectures, but it seems
like the best flag based on code review.

> patch #2: switch to __ARCH_HAS_SA_RESTORER, no cc stable
>
> I'm assuming this is all for 3.10, btw.  If you think it should be in
> 3.9 then you need to write scarier changelogs.

Well, I'm not sure it needs to be scarier; it's a serious local ASLR
info leak. I was hoping it could go into 3.9 since the expectation is
for it to go to stable, so why not put it in 3.9 now?

Do you want me to spin up the 2-patch solution or is it too much of a hack?

-Kees

-- 
Kees Cook
Chrome OS Security
