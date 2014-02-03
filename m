Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaBCT5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:57:13 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36073 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaBCT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:57:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ3m7Br60ph=Ja_ggJAp9cb5fNJy2O1rRHeJW_jjeTJbYmG3UA@mail.gmail.com>
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
 <52EFEF0A.9080101@amacapital.net> <CAJ3m7Br60ph=Ja_ggJAp9cb5fNJy2O1rRHeJW_jjeTJbYmG3UA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Feb 2014 11:56:51 -0800
Message-ID: <CALCETrXBRW=x9myjxzZB+ChtPiH9zjNOd=YLtCp61ib3bqEpKA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] epoll: read(),write(),ioctl() interface
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 11:42 AM, Nathaniel Yazdani
<n1ght.4nd.d4y@gmail.com> wrote:
> On 2/3/14, Andy Lutomirski <luto@amacapital.net> wrote:
>> On 02/02/2014 06:17 PM, Nathaniel Yazdani wrote:
>>> Hi everyone,
>>>
>>> This patch series adds support for read(), write(), and ioctl()
>>> operations
>>> on eventpolls as well as an associated userspace structure to format the
>>> eventpoll entries delivered via read()/write() buffers. The new
>>> structure,
>>> struct epoll, differs from struct epoll_event mainly in that it also
>>> holds
>>> the associated file descriptor. Using the normal I/O interface to
>>> manipulate
>>> eventpolls is much neater than using epoll-specific syscalls while also
>>> allowing for greater flexibility (theoretically, pipes could be used to
>>> filter access). Specifically, write() creates, modifies, and/or removes
>>> event
>>> entries stored in the supplied buffer, using the userspace identifier to
>>> check whether an entry exists and removing it if no events are set to
>>> trigger
>>> it, while read() simply waits for enough events to fill the provided
>>> buffer.
>>> As timeout control is essential for polling to be practical, ioctl() is
>>> used
>>> to configure an optional timeout, which is infinite by default.
>>
>> If major changes are made to the epoll API, I want a way to do a bunch
>> of EPOLL_CTL_MODs and a wait, all in one syscall.  Even better: allow
>> more flexible timeouts (CLOCK_MONOTONIC, CLOCK_REALTIME, etc) at the
>> same time.
>>
>> Since this can't do that, I'm not terribly inspired.
>>
>> --Andy
>
> So are you saying that those features you mentioned are specifically sought
> after for the kernel? If so I'd like to take a crack at some of them,
> may as well
> get some use out of my new knowledge of epoll internals :)

If by "sought after", you mean "is there at least one epoll user who
wants them", then yes :)

I think that EPOLLET and EPOLLONESHOT are giant hacks, and that what
everyone really wants is the ability to very efficiently toggle events
on and off.  The ability to do it simultaneously and inexpensively
with epoll_wait would make it happen.

--Andy

>
> Thanks for your input,
> Nate Yazdani



-- 
Andy Lutomirski
AMA Capital Management, LLC
