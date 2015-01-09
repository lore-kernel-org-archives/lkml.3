Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbbAIMaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:30:15 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41152 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbAIMaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:30:08 -0500
MIME-Version: 1.0
In-Reply-To: <CADxyqMGJxNMvXr4YtiZus0g1+a1EdamNbnr54qqitByZa8idkQ@mail.gmail.com>
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
	<CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
	<20150108134849.671ee761@lxorguk.ukuu.org.uk>
	<CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com>
	<CADxyqMGJxNMvXr4YtiZus0g1+a1EdamNbnr54qqitByZa8idkQ@mail.gmail.com>
Date: Fri, 9 Jan 2015 18:00:07 +0530
Message-ID: <CADxyqMF4Pajd9oA1FOeb=XH9WVw83D_iX7JoS6GKZDkCeZf-Ug@mail.gmail.com>
Subject: Fwd: Question about kernel interfaces
From: Siddhartha De <siddhartha.de87@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Siddhartha De <siddhartha.de87@gmail.com>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the last message bounced ...


Thanks ,

Kernel Newbie :)




---------- Forwarded message ----------
From: Siddhartha De <siddhartha.de87@gmail.com>
Date: Fri, Jan 9, 2015 at 5:50 PM
Subject: Fwd: Question about kernel interfaces
To: linux-kernel <linux-kernel@vger.kernel.org>, Siddhartha De
<siddhartha.de87@gmail.com>, kernelnewbies@kernelnewbies.org


Hi ,

Dear Kernel Newbies ,

I have had some discussions regarding this on the IRC but I thought it
would be a better idea to post it to the mailing list as well ....
just in case someone came up with any ideas/comments/suggestions later
....


PS :- I am marking a copy to the main linux-kernel list so that any
discussions automatically gets forwarded there ...

Thanks ,

Kernel Newbie :)


---------- Forwarded message ----------
From: Siddhartha De <siddhartha.de87@gmail.com>
Date: Fri, Jan 9, 2015 at 5:18 PM
Subject: Re: Question about kernel interfaces
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>


Hi  ,

Thanks for your reply . Really appreciate your taking time out to
answer this ...

1>
> Are all drivers in future required to expose interfaces in sysfs ?

> Only if they need one (some will appear automatically as you enable power
management and the like).

Just wanted to point out something  :-

Quoting from makelinux website :-
http://www.makelinux.net/books/lkd2/ch17lev1sec8

"The sysfs filesystem is currently the place for implementing
functionality previously reserved for ioctl() calls on device nodes or
the procfs filesystem. These days, the chic thing to do is implement
such functionality as sysfs attributes in the appropriate directory.
For example, instead of a new ioctl() on a device node, add a sysfs
attribute in the driver's sysfs directory. Such an approach avoids the
type-unsafe use of obscure ioctl() arguments and the haphazard mess of
/proc. "


Quoting from the busybox mailing list archives :-

Hi vda, all,

ISTR that sysfs was the long-term plan of the kernel folks and that they
mean to completely(?) drop ioctl support.

In what timeframe should we migrate to "pure" sysfs and drop using
any ioctls (if a sysfs interface exists)?


cheers,
Bernhard

Quote from livejournal

http://zaitcev.livejournal.com/84788.html


sysfs is the new ioctl



With all these spread all over the net , any newbie like myself is
bound to get confused ... add to that I just saw some old mails from
Linus where he blasts the ioctl way of doing things (
http://yarchive.net/comp/linux/ioctl.html )  :)


2> It's not entirely impossible to make syscalls remotable. It's been done to
some extent at least two ways. Read up on plan 9 (which did try and take
Unix much more networked and within the classic tradition of Unix as a
small clean OS),

Thanks for the advice , I did read up a bit on Plan 9 , but from what
I understood it was trying to abstract the network
to the user ... a bit different from what my confusion is .... but a
great resource nevertheless

3>


>I'm not sure I'd pick Java for this either - Java is very weak in this
area as it tends to expose notions of locality and what is and isn't
remote when doing method invocations. Languages like smalltalk on the
other hand got this right many years before.


Yeah ... the reason I mentioned Java is because it represents a
typical high level language commonly used by today's programmers ...
the problem with all these languages is that while they do a fine job
when writing web based applications they really make it difficult to
access low level system calls ( for eg talking to the driver and stuff
) . Moreover when a library is written for say Linux or Windows the
library becomes tied to that particular language ( the one it is
written in ) ... for eg let us say we write a new library in C for
playing mp3 's in Linux ... if we are to write a user space program
and want to access the library 's functionality we have to write the
userspace program in C ... if we write it in any other language ( say
Java ) we have to use other methods like Java Native Interface ( JNI
... or more recently JNA ) to access this ... not  a good way .

          What I am saying is let us expose the library over http/any
other network protocol ... if any other language needs to access the
library's functionality it simply makes a request like :-

 http://localhost:7000/libmp3/foo?arg1=something&arg2=something

This way we avoid a lot of rework since once a library is written it's
functionality is exposed to all languages ( Java / PHP / Python )  .

Taking this idea further , could we also expose driver IOCTL's over
the network ?

For eg to open the cd rom drive we would be calling the following url :-

(assuming device is /dev/cdrom )


http://localhost:7000/IOCTL/IOCTL_EJECT?device=/dev/cdrom

The listener program ( our interpreter listening on port 7000 ) would
be taking this url call and doing the actual IOCTL call

file_handle= open ( /dev/cdrom )
call_IOCTL ( file_handle,IOCTL_EJECT, &some_structure )

The idea of exposing all these interfaces as url's is not to make them
accessible over the network ( although this could be a possibility
...)  but simply to make them accessible from any user space program
in a language neutral way ...


Thanks

Kernel Newbie    :)





On Thu, Jan 8, 2015 at 7:18 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> Is sysfs 'supposed' to be a read only where various kernel parameters
>> are exposed to be read ? Or are they 'supposed' to be writable too ?
>
> You can create either
>
>> Are all drivers in future required to expose interfaces in sysfs ?
>
> Only if they need one (some will appear automatically as you enable power
> management and the like).
>
>> If the answer to the above is true , then would we be really requiring
>> IOCTL calls at all anymore ... because all that we would need to do to
>> make a driver do something is to change values in some of the files in
>> sysfs ... for eg to call a ioctl called DO_SOMETHING on driver D1 we
>> would be doing :
>>
>> echo 1> /sysfs/D1/IOCTLS/DO_SOMETHING  ( or something like that ... :) )
>
> Try implementing a few this way and you'll discover you can't. ioctls
> happen on file handles which are tied to instances of an object not to
> the driver. ioctl also allows read/write pairs so can be serializing and
> sequenced in a way sysfs can't.
>
>> Are there any plans of exposing the kernel api ( that is syscalls and
>> libc ) as sysfs files ... for eg
>>
>> echo 1> /sysfs/libc/get_system_time
>> cat /sysfs/libc/results/system_time
>
> Time is an example where you could implement it via sysfs. It's an
> unusual case in that its global and stateless.
>
>> Would it be a good idea to do this ?
>
> No, probably not.
>
>> How about exposing core system calls , libc and any new libraries over
>> http/over the network  ? This would make calling ioctls and really low
>> level stuff from high level languages like Java a trivial process .
>> For eg right now if I wanted to call some function say foo () in
>> library my_library.so in Java I would have to take the JNI/JNA route
>> ... doable but not exactly 'easy' ( same for other high level
>> languages ) ... whereas in the new way all I would have to do is send
>> a request to say :-
>>   http://localhost:7000/my_library/foo?arg1=something,arg2=something
>> ( Just wanted a frank discussion on this idea .... )
>
> Except that you've also got to transfer the data and the authentication
> back and forth. You need much more than sysfs for this, you need some way
> to pass messages securely, and to do work on a remote node on your
> behalf. You need some way to locate a resource.
>
> It's not entirely impossible to make syscalls remotable. It's been done to
> some extent at least two ways. Read up on plan 9 (which did try and take
> Unix much more networked and within the classic tradition of Unix as a
> small clean OS), and perhaps also on MOSIX, which took a very different
> approach to running on a cluster of boxes as one instance. Another odd
> example to look at is Minix. Minix treats all syscalls internally as
> messages between user processes and services like the file system. Minix
> never really made use of it, but it does mean its much easier to do
> remote syscall models in Minix than Linux. (in part I suspect this comes
> from Tanenbaum's Amoeba and similar work).
>
> I'm not sure I'd pick Java for this either - Java is very weak in this
> area as it tends to expose notions of locality and what is and isn't
> remote when doing method invocations. Languages like smalltalk on the
> other hand got this right many years before.
>
> Alan
>


On Wednesday Jan 7th Siddhartha De (siddhartha.de87@gmail.com ) wrote :-


I have already asked this question on the kernelnewbies IRC but I
wanted a bit of feedback from the Linux gurus ...


Is sysfs 'supposed' to be a read only where various kernel parameters
are exposed to be read ? Or are they 'supposed' to be writable too ?

Are all drivers in future required to expose interfaces in sysfs ?

If the answer to the above is true , then would we be really requiring
IOCTL calls at all anymore ... because all that we would need to do to
make a driver do something is to change values in some of the files in
sysfs ... for eg to call a ioctl called DO_SOMETHING on driver D1 we
would be doing :

echo 1> /sysfs/D1/IOCTLS/DO_SOMETHING  ( or something like that ... :) )

Are there any plans of exposing the kernel api ( that is syscalls and
libc ) as sysfs files ... for eg

echo 1> /sysfs/libc/get_system_time
cat /sysfs/libc/results/system_time

Would it be a good idea to do this ?

How about exposing core system calls , libc and any new libraries over
http/over the network  ? This would make calling ioctls and really low
level stuff from high level languages like Java a trivial process .
For eg right now if I wanted to call some function say foo () in
library my_library.so in Java I would have to take the JNI/JNA route
... doable but not exactly 'easy' ( same for other high level
languages ) ... whereas in the new way all I would have to do is send
a request to say :-


http://localhost:7000/my_library/foo?arg1=something,arg2=something  (
Just wanted a frank discussion on this idea .... )



Thanking you in anticipation ,

 Yours sincerely ,

  Kernel newbie
