Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3JIC1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:27:19 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:61090 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3JIC1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <20131009020623.GG13318@ZenIV.linux.org.uk>
References: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
	<CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
	<20131009011833.GE13318@ZenIV.linux.org.uk>
	<CA+55aFyej+u+JmWeGZgVECGFQPY909HkDc83+fuC5M1r1HSeHA@mail.gmail.com>
	<20131009020623.GG13318@ZenIV.linux.org.uk>
Date: Tue, 8 Oct 2013 19:27:15 -0700
X-Google-Sender-Auth: ME-i_aROttx3KwcAqspdI8Ds5Gg
Message-ID: <CA+55aFz4JWB65bQRu7J6vQt7NPOoGKTxCYW4GQ8o5PHTZsYWKg@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 7:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Oct 08, 2013 at 06:38:47PM -0700, Linus Torvalds wrote:
>> On Tue, Oct 8, 2013 at 6:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> > Point, but I would argue that we should yell very loud if we get 0 from
>> > vfs_write() for non-zero size.  I'm not sure if POSIX allows write(2)
>> > to return that, but a lot of userland code won't be expecting that and
>> > won't be able to cope...
>>
>> Actually POSIX very much allows zero returns. O_NDELAY is mentioned as
>> a possible cause, in addition to zero-sized writes themselves, of
>> course.
>
> Umm...  What it says is "If some data can be written without blocking the
> thread, write() shall write what it can and return the number of bytes
> written. Otherwise, it shall return -1 and set errno to EAGAIN."

Look closer.

  ".. most historical implementations return zero (with the O_NDELAY
flag set, which is the historical predecessor of O_NONBLOCK .."

>> Also, writing to (but not past) the end of a block device returns 0
>> for "end of device", iirc.
>
> What do you mean?  If the starting position is below the end of device,
> we get a non-zero length write, not exceeding the end.  If it's at
> the end of device, we get -ENOSPC.  It's out of scope for POSIX, but
> Linux is definitely acting that way...

Hmm. I'm pretty sure I've seen zero returns for EOF somewhere..

         Linus
