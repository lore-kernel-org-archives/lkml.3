Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbARJeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 04:34:03 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43247 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbbARJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 04:33:56 -0500
MIME-Version: 1.0
In-Reply-To: <CADxyqMGtew47Gfzq=1u46qjkLsn+AkB-fGWbAtODAbHgi3DM9g@mail.gmail.com>
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
	<CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
	<20150108134849.671ee761@lxorguk.ukuu.org.uk>
	<CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com>
	<20150114163317.46a1ecec@lxorguk.ukuu.org.uk>
	<CADxyqMGtew47Gfzq=1u46qjkLsn+AkB-fGWbAtODAbHgi3DM9g@mail.gmail.com>
Date: Sun, 18 Jan 2015 15:03:55 +0530
Message-ID: <CADxyqMEjs7Xpy7Xqi7zbyOtCwNWfT1bK22Paf3wSMP8YEVjyUQ@mail.gmail.com>
Subject: Re: Question about kernel interfaces
From: Siddhartha De <siddhartha.de87@gmail.com>
To: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan Thanks for your reply ... really helped a lot

>> Taking this idea further , could we also expose driver IOCTL's over
>> the network ?
>>
>> For eg to open the cd rom drive we would be calling the following url :-
>
> You could but why would you make the network visible. If you look at real
> clustered systems they all hide the network. You don't care where it is,
> often you don't even care where the drive is.
>
> eject /dev/cdrom
>
> on such a system lets the kernel figure out who to ask to eject it.
>
> The job of an OS is to abstract details like that. In a clustered OS I
> want to be able to type
>
>         mount mydisk
>
> and I don't care who, where or how it gets mounted so long as it appears.
>
> Alan

OK ... the idea of exposing driver ioctl 's or low level system calls
or library calls over the network isn't for use in clustered systems (
although it certainly could be used  there ) ... the reason I want to
expose all these systems is to provide an universal interface that any
programming language can request services from .

To bring home the point to the Linux folks let's talk about a
particular example ....

Let's say you need to call an ioctl from a shell script ( I know its a
very rare use case but please bear with me ... :) )

So the current way of doing it is probably to write a C program which
actually calls the ioctl and then call the C program from the shell
script ...

However if we exposed the IOCTL as a web url we could easily call its
services by using a simple utility like curl . So in our shell script
we would probably write :-

curl http://localhost:7000/IOCTL/IOCTL_EJECT?device=/dev/cdrom

and the IOCTL_EJECT ioctl would get called on /dev/cdrom
that is ioctl ( &handle_to_/dev/cdrom , IOCTL_EJECT , &some_buffer )
would get called ( by our translator running as a separate program or
as a service daemon )

Taking this concept further all libraries could expose their functions
via such an interface .

And the benefits would go far beyond just shell scripts . Once the
interface has been exposed any high level language can use the
functionality provided by drivers , libraries to their full extent .

If we want to expose the full power of drivers and other libraries to
the entire gamut of programmers regardless of whatever language they
are coding in , this could be a good way of doing it  :)

Thanking you ,
Yours sincerely ,
Kernel Newbie


On Sat, Jan 17, 2015 at 1:07 AM, Siddhartha De
<siddhartha.de87@gmail.com> wrote:
> FYI ...
>
>
> ---------- Forwarded message ----------
> From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Date: Wed, Jan 14, 2015 at 10:03 PM
> Subject: Re: Question about kernel interfaces
> To: Siddhartha De <siddhartha.de87@gmail.com>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
>
>
>> Just wanted to point out something  :-
>>
>> Quoting from makelinux website :-
>> http://www.makelinux.net/books/lkd2/ch17lev1sec8
>>
>> "The sysfs filesystem is currently the place for implementing
>> functionality previously reserved for ioctl() calls on device nodes or
>> the procfs filesystem. These days, the chic thing to do is implement
>> such functionality as sysfs attributes in the appropriate directory.
>> For example, instead of a new ioctl() on a device node, add a sysfs
>> attribute in the driver's sysfs directory. Such an approach avoids the
>> type-unsafe use of obscure ioctl() arguments and the haphazard mess of
>> /proc. "
>
> And is wrong. Certainly rather clueless people had the idea they could
> make ioctl go away using sysfs, and then everyone wrote about it. Anyone
> who actually thought about the problem realised immediately they are not
> semantically equivalent.
>
>> sysfs is the new ioctl
>
> And as was pointed out even then they are not semantically equivalent so
> everyone who was talking about "sysfs being the new ioctl" was basically
> talking out the wrong end.
>
> What was done was to stop filling drivers with ioctls for pieces of
> general information which didn't have a context attached to it or
> sequence. Things like power state, what type it is, what bus it is on
> etc. That avoided having zillions of ioctls but at the cost of memory.
>
>> Taking this idea further , could we also expose driver IOCTL's over
>> the network ?
>>
>> For eg to open the cd rom drive we would be calling the following url :-
>
> You could but why would you make the network visible. If you look at real
> clustered systems they all hide the network. You don't care where it is,
> often you don't even care where the drive is.
>
> eject /dev/cdrom
>
> on such a system lets the kernel figure out who to ask to eject it.
>
> The job of an OS is to abstract details like that. In a clustered OS I
> want to be able to type
>
>         mount mydisk
>
> and I don't care who, where or how it gets mounted so long as it appears.
>
> Alan
