Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3HGQ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:58:32 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43927 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3HGQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130807162147.GA31460@redhat.com>
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com>
 <52015ADB.30408@mit.edu> <20130807162147.GA31460@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 Aug 2013 09:58:09 -0700
Message-ID: <CALCETrVELXkdccJZQRsm_9mtXrD-8nW_sRW_p-SWNVsXcqX2Cg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Chen Gang <gang.chen@asianux.com>, Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>, holt@sgi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 9:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/06, Andy Lutomirski wrote:
>>
>> I assume that what the man page means is that the return value is
>> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
>> the return value is still "current".
>
> Probably... Still
>
>         On success, the previous value of fsuid is returned.
>         On error, the current value of fsuid is returned.
>
> looks confusing. sys_setfsuid() always returns the old value.
>
>> (FWIW, this behavior is awful and is probably the cause of a security
>> bug or three, since success and failure are indistinguishable.
>
> At least this all looks strange.
>
> I dunno if we can change this old behaviour. I won't be surprized
> if someone already uses setfsuid(-1) as getfsuid().

I suspect that changing this without introducing security or other
bugs is impossible.  If someone wanted to add new_setfsuid that
returned an error when it failed, that would be a different story.
(I'm not going to do that myself.)

>
> And perhaps the man page should be changed. Add Michael.

Agreed.  The text is a bit odd.

>
> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
