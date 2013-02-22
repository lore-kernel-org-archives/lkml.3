Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3BVJB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:01:26 -0500
Received: from ares07.inai.de ([5.9.24.206]:37826 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab3BVJBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:01:22 -0500
Date: Fri, 22 Feb 2013 10:01:19 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Pavel Emelyanov <xemul@parallels.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        CRIU <criu@openvz.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.4
In-Reply-To: <5124B107.1040302@parallels.com>
Message-ID: <alpine.LNX.2.01.1302220955160.1805@nerf07.vanv.qr>
References: <5124B107.1040302@parallels.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2013-02-20 12:18, Pavel Emelyanov wrote:
>
>As was planned, the v0.4 of C/R tools is out, right after the Linux v3.8.
>
>The most valuable thing in this release, is that all the kernel patches
>we had are now merged, and thus what crtools-v0.4 can do will work on
>the upstream kernel (properly configured)!

I have trouble compiling that.


$ + make -j10 'CFLAGS=-fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g' V=1
gcc -M -MT arch/x86/crtools.d -MT arch/x86/crtools.o -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g   arch/x86/crtools.c -o arch/x86/crtools.d
arch/x86/crtools.c:5:21: fatal error: asm/fpu.h: No such file or directory

fpu.h does not exist in /usr/include, nor does it exist in $linux/arch/x86/
or $linux/include. Apparently it does exist in crtools, but there are no
more flags pointing to crtools/include/. Which probably means you should
place mandatory CFLAGS not in CFLAGS, but your own variable.
