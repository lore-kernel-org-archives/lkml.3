Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbaD2N3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:29:35 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:45871 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbaD2N3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:29:33 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 29 Apr 2014 15:29:12 +0200
Message-ID: <CAKgNAkiq+yA7_tnvCVXemFy6P5F0eMccw18-GdqFthuzagvF5Q@mail.gmail.com>
Subject: Re: fanotify API: FMODE_NONOTIFY, FMODE_EXEC, FMODE_NOCMTIME
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: linux-man <linux-man@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += LKML]

Eric, Jan, (or anyone)

Can you offer any insight on Heinrich's question, below?

Cheers,

Michael

On Sun, Apr 13, 2014 at 4:05 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> On 06.04.2014 14:18, Michael Kerrisk (man-pages) wrote:
>>>
>>> ==
>>> >
>>> >  >> I notice that the FDs returned by read()s from the FAN FD have the
>>> >  >> FMODE_NONOTIFY flag (fcntl(F_GETFL)) flag set. If you know what
>>> > that's
>>> >  >> about, it would be good to say something about. But, if not, do not
>>> >  >> worry--just place a FIXME in the page source of fanotify(7)
>>> >
>>> >Fixed in fanotify.7
>>> >If the listener accesses the file through the file descriptor provided
>>> >no additional events are created.
>>
>> Ahh -- thanks for filling in that piece. I see that you refer to
>> fcntl(2) when discussing that flag. But fcntl(2) does not
>> mention that flag. I would rather see an explanation of this flag
>> in the fanotify pages.
>>
>
> I wrote a small test program and found:
>
> The flag FMODE_NONOTIFY can be read by function fcntl from userspace.
> int flag = fcntl(fd, F_GETFL)
>
> In include/uapi/asm-generic/fcntl.h I found the following comment:
>
> /*
>  * FMODE_EXEC is 0x20
>  * FMODE_NONOTIFY is 0x1000000
>  * These cannot be used by userspace O_* until internal and external open
>  * flags are split.
>  * -Eric Paris
>  */
>
> The definition of FMODE_NONOTIFY is in include/linux/fs.h but this
> include is only used to compile the Kernel and not supposed to be used by
> userspace.
>
> I think it is quite annoying that fcntl can return a flag that is not
> described in the manpage of fcntl and that is not defined in fcntl.h.
>
> But FMODE_NONOTIFY is not the only flag:
>
> I was able to pass
> 0x20 (FMODE_EXEC), and
> 0x800 (FMODE_NOCMTIME)
> to fanotify_init and received them as flag in the file descriptors for the
> fanotify events.
> I wonder why fanotify_init does not check import parameter event_f_flags and
> return an error if any inappropriate value is set.
>
> Should I put this into the BUGS section?
>
> Should the name of the flag FMODE_NONOTIFY be mentioned at all in the man
> pages?
>
> Or should we write:
>
> .I fd
> This is an open file descriptor for the object being accessed or
> .B FAN_NOFD
> if a queue overflow occurred.
> The file descriptor can be used to access the contents of the monitored file
> or
> directory.
> It has an internal flag set, that suppresses fanotify event generation.
> Hence when the receiver of the fanotify event accesses the notified file or
> directory using this file descriptor no additional events will be created.
> The reading application is responsible for closing the file descriptor.
>
> Best regards
>
> Heinrich Schuchardt



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
