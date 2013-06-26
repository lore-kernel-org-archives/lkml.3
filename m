Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3FZRr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:47:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40054 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:47:26 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130626171501.GA32056@kroah.com>
References: <CA+icZUWDDCsXBK4+s4fEbM_AGj3EnfCRAe2=yE+8_MT4mauPXg@mail.gmail.com>
	<CA+icZUXtTxVUfOmFak9GzyUdGa7bBuxTr2CJEY0vNn0bH2-4Vw@mail.gmail.com>
	<20130626172446.51f0bd5f@skate>
	<20130626153236.GA29455@kroah.com>
	<CA+icZUXijuvgQGGqvpPUzrzgC0n4ipo3eFf9vnFa+4jHoTDgDw@mail.gmail.com>
	<20130626171501.GA32056@kroah.com>
Date: Wed, 26 Jun 2013 19:47:24 +0200
Message-ID: <CA+icZUXVuTHH2s2-dbTwUTLwdPiuqr8LKzeGQWwfaJQebFj=Dw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 26 [ vfs | block | fuse (cpuidle)
 releated? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 7:15 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 26, 2013 at 05:36:03PM +0200, Sedat Dilek wrote:
>> On Wed, Jun 26, 2013 at 5:32 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Jun 26, 2013 at 05:24:46PM +0200, Thomas Petazzoni wrote:
>> >> Dear Sedat Dilek,
>> >>
>> >> On Wed, 26 Jun 2013 16:50:55 +0200, Sedat Dilek wrote:
>> >>
>> >> > [ TO/CC char-misc folks ]
>> >> >
>> >> > The CULPRIT commit [1] due to my git-bisecting is:
>> >> >
>> >> > commit 585d98e00ba7a5e2abe65f7a1eff631cb612289b
>> >> > "char: misc: assign file->private_data in all cases"
>> >> >
>> >> > After reverting it, my system boots up fine again.
>> >> >
>> >> > Can someone from the char-misc folks look at that?
>> >>
>> >> Ok. My understanding is that the misc device registered by
>> >> fs/fuse/dev.c:fuse_dev_init() makes the assumption that
>> >> file->private_data == NULL when a misc device is opened. But I'm not
>> >> sure to fully understand the code flow of the FUSE filesystem.
>> >>
>> >> And since it doesn't provide its own implementation of the ->open()
>> >> operation, the misc infrastructure was leaving the file->private_data
>> >> defined to NULL before my patch.
>> >>
>> >> With my patch, the file->private_data gets assigned unconditionally
>> >> (regardless of whether the misc driver provides or does not provide a
>> >> ->open() operation) which modifies the unwritten assumption that fuse
>> >> was making about the initial value of file->private_data. I believe the
>> >> assumption made by fuse over the initial value of this variable is a
>> >> bit fragile.
>> >>
>> >> Maybe the FUSE code needs to be slightly adjusted to not make this
>> >> assumption?
>> >
>> > As the FUSE code was working properly before this change, I think this
>> > misc core change needs to be reverted, so I'll go do that in a bit.
>> >
>>
>> Good, sound reasonable.
>>
>> I was not aware that char-misc and fuse code is so interwoven (hope
>> this is the right word).
>
> The fuse driver is a misc device, so the fuse code depends on the misc
> core to work properly, that's the dependancy here.
>
> I've now reverted this change, thanks again for the report and the quick
> determination of the problem.
>

All this early-testing results sometimes in nice use-cases/test-cases.

If I think of the IPC-MSG issue (fakeroot & 'make deb-pkg') I had in -next...
I have sent a patch to Linux-Testing-Project to enhance the IPC test-suite.
As a goodie I catched a BASHISM bug for dash shell in runltp script :-).

I forgot a bug-report for Debian's fakeroot... The shipped DEBUG
doc-file is outdated.

The harder part is to convince the maintainers that sth. is/went wrong :-).

Personally, I am happy when Friday's Linux-Next is "bug-free" for me.

- Sedat -

> greg k-h
