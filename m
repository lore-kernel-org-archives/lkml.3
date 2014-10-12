Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaJLRGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:06:39 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42612 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLRGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:06:36 -0400
MIME-Version: 1.0
In-Reply-To: <20141012164023.GA13217@1wt.eu>
References: <1408474660-24999-1-git-send-email-beber@meleeweb.net>
	<1408474660-24999-3-git-send-email-beber@meleeweb.net>
	<CAJUuVQ7eEn8r2mAQKmydTDvDgSXYKjUH15VPEQfOVPJxNtU9ag@mail.gmail.com>
	<20141012164023.GA13217@1wt.eu>
Date: Sun, 12 Oct 2014 13:06:35 -0400
Message-ID: <CAJUuVQ6vCxBkBAZbRsw+zOh4==Y7AYnJ8_5-HEx9unsyuO1V4Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: handle module compression while running 'make modules_install'.
From: Andev <debiandev@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Bertrand Jacquin <beber@meleeweb.net>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 12:40 PM, Willy Tarreau <w@1wt.eu> wrote:
> Hi,
>
> On Sun, Oct 12, 2014 at 11:50:59AM -0400, Andev wrote:
>> Hello Bertrand,
>>
>> Does this need any user space support? Cos currently on a debian
>> testing box(powerpc) enabling this options causes a boot hang while
>> mounting the root file system.
>
> I suspect that your module-ini-tools/kmod are built without support for
> compressed modules. One method to verify this is to run it against ldd :
>
> $ ldd /sbin/modprobe
>         linux-vdso.so.1 (0x00007fff918ed000)
>         libkmod.so.2 => /lib64/libkmod.so.2 (0x00007ff9317f1000)
>         libpthread.so.0 => /lib64/libpthread.so.0 (0x00007ff9315d5000)
>         libc.so.6 => /lib64/libc.so.6 (0x00007ff931214000)
>         liblzma.so.5 => /lib64/liblzma.so.5 (0x00007ff930ff2000)
>         libz.so.1 => /usr/lib64/libz.so.1 (0x00007ff930ddd000)
>         /lib64/ld-linux-x86-64.so.2 (0x00007ff931a06000)
>
> As you can see, mine depends on liblzma and libz so it was clearly built
> with support for both of them.
>

Yes, that indeed seems to be the problem. On my machine:

$ ldd /sbin/modprobe
linux-vdso32.so.1 (0x00100000)
libc.so.6 => /lib/powerpc-linux-gnu/libc.so.6 (0x6fe17000)
/lib/ld.so.1 (0x20229000)

Thanks!
-- 
Andev
