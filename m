Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3BVJNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:13:35 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44055 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3BVJNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:13:31 -0500
Date: Fri, 22 Feb 2013 13:13:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Pavel Emelyanov <xemul@parallels.com>, CRIU <criu@openvz.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [CRIU] [Announce] Checkpoint-restore tool v0.4
Message-ID: <20130222091326.GA17499@moon>
References: <5124B107.1040302@parallels.com>
 <alpine.LNX.2.01.1302220955160.1805@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1302220955160.1805@nerf07.vanv.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 10:01:19AM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2013-02-20 12:18, Pavel Emelyanov wrote:
> >
> >As was planned, the v0.4 of C/R tools is out, right after the Linux v3.8.
> >
> >The most valuable thing in this release, is that all the kernel patches
> >we had are now merged, and thus what crtools-v0.4 can do will work on
> >the upstream kernel (properly configured)!
> 
> I have trouble compiling that.
> 
> $ + make -j10 'CFLAGS=-fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g' V=1
> gcc -M -MT arch/x86/crtools.d -MT arch/x86/crtools.o -fmessage-length=0 -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g   arch/x86/crtools.c -o arch/x86/crtools.d
> arch/x86/crtools.c:5:21: fatal error: asm/fpu.h: No such file or directory
> 
> fpu.h does not exist in /usr/include, nor does it exist in $linux/arch/x86/
> or $linux/include. Apparently it does exist in crtools, but there are no
> more flags pointing to crtools/include/. Which probably means you should
> place mandatory CFLAGS not in CFLAGS, but your own variable.

Thanks for report, i'll fix that.
