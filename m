Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaJLQkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:40:46 -0400
Received: from 1wt.eu ([62.212.114.60]:29900 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbaJLQkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:40:42 -0400
Date: Sun, 12 Oct 2014 18:40:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andev <debiandev@gmail.com>
Cc: Bertrand Jacquin <beber@meleeweb.net>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] kbuild: handle module compression while running 'make modules_install'.
Message-ID: <20141012164023.GA13217@1wt.eu>
References: <1408474660-24999-1-git-send-email-beber@meleeweb.net> <1408474660-24999-3-git-send-email-beber@meleeweb.net> <CAJUuVQ7eEn8r2mAQKmydTDvDgSXYKjUH15VPEQfOVPJxNtU9ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJUuVQ7eEn8r2mAQKmydTDvDgSXYKjUH15VPEQfOVPJxNtU9ag@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 12, 2014 at 11:50:59AM -0400, Andev wrote:
> Hello Bertrand,
> 
> Does this need any user space support? Cos currently on a debian
> testing box(powerpc) enabling this options causes a boot hang while
> mounting the root file system.

I suspect that your module-ini-tools/kmod are built without support for
compressed modules. One method to verify this is to run it against ldd :

$ ldd /sbin/modprobe
        linux-vdso.so.1 (0x00007fff918ed000)
        libkmod.so.2 => /lib64/libkmod.so.2 (0x00007ff9317f1000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007ff9315d5000)
        libc.so.6 => /lib64/libc.so.6 (0x00007ff931214000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007ff930ff2000)
        libz.so.1 => /usr/lib64/libz.so.1 (0x00007ff930ddd000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ff931a06000)

As you can see, mine depends on liblzma and libz so it was clearly built
with support for both of them.

Regards,
Willy

