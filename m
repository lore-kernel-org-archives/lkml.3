Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3HHBfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 21:35:52 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:61445 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab3HHBfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <5202F4A3.5070603@asianux.com>
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com>
 <52015ADB.30408@mit.edu> <20130807162147.GA31460@redhat.com>
 <CALCETrVELXkdccJZQRsm_9mtXrD-8nW_sRW_p-SWNVsXcqX2Cg@mail.gmail.com> <5202F4A3.5070603@asianux.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 Aug 2013 18:35:30 -0700
Message-ID: <CALCETrUiVT5p5oHEHTavJtdWo3d0BV+Fexurpr-Z9ockwX1SoQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
To: Chen Gang <gang.chen@asianux.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        holt@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 6:30 PM, Chen Gang <gang.chen@asianux.com> wrote:
> On 08/08/2013 12:58 AM, Andy Lutomirski wrote:
>> On Wed, Aug 7, 2013 at 9:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 08/06, Andy Lutomirski wrote:
>>>>
>>>> I assume that what the man page means is that the return value is
>>>> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
>>>> the return value is still "current".
>>>
>>> Probably... Still
>>>
>>>         On success, the previous value of fsuid is returned.
>>>         On error, the current value of fsuid is returned.
>>>
>>> looks confusing. sys_setfsuid() always returns the old value.
>>>
>>>> (FWIW, this behavior is awful and is probably the cause of a security
>>>> bug or three, since success and failure are indistinguishable.
>>>
>>> At least this all looks strange.
>>>
>>> I dunno if we can change this old behaviour. I won't be surprized
>>> if someone already uses setfsuid(-1) as getfsuid().
>>
>
> Oh, really it is.
>
> Hmm... as a pair function, we need add getfsuid() too, if we do not add
> it, it will make negative effect with setfsuid().
>
> Since it is a system call, we have to keep compitable.
>
> So in my opinion, better add getfsuid2()/setfsuid2() instead of current
> setfsuid()

How about getfsuid() and setfsuid2()?

--Andy
