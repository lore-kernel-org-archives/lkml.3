Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaK0VtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:49:10 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:57174 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaK0VtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:49:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: grant.likely@linaro.org, fengguang.wu@intel.com, kbuild-all@01.org,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] m32r: Add missing big-endian I/O accessors
Date: Thu, 27 Nov 2014 22:48:56 +0100
Message-ID: <3837177.boLNi8fnoI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417112193-14400-2-git-send-email-cernekee@gmail.com>
References: <1417112193-14400-1-git-send-email-cernekee@gmail.com> <1417112193-14400-2-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/lekq+Ot7dWeRrFBruNzr0/riXdLwMDJ7fhWT8+HPqS
 XFBrrce33jlCXLxpjwRrE2moOHnh3Y2gZSC/k30ucL9gAY6+oS
 ryhw/ZiJBk8Djwxvyhhlt3B/bskeNQwr6OpQWwITksQGAXn3+k
 RATvaA1+QDZnUeLWIw1bNM8oaH3H9NYefJJ8dkFsvcGBw2qTA3
 +bmbfKaPZdgCCBTcVyG98ItOIL6VotUyecQirD6Nv8LzA+9AkI
 VUYiQcWrNjrGu+sUPRsaWzT0Wws/5BLCbhDRFlM81UYGq1+Wa2
 4B01YwTh0G/1ihABS1D6fDNfgwMjGhl82a5KLrB1yc8ocw6aBD
 jWPy2TCzEBIQYlLYemLw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 10:16:33 Kevin Cernekee wrote:
> m32r doesn't use GENERIC_IOMAP, and it doesn't currently implement e.g.
> ioread32be() on its own.  Add definitions to <asm/io.h> to fix build
> failures in common drivers that use these functions.
> 
>    drivers/tty/serial/8250/8250_core.c: In function 'mem32be_serial_out':
> >> drivers/tty/serial/8250/8250_core.c:434:2: error: implicit declaration of function 'iowrite32be' [-Werror=implicit-function-declaration]
>      iowrite32be(value, p->membase + offset);
>      ^
>    drivers/tty/serial/8250/8250_core.c: In function 'mem32be_serial_in':
> >> drivers/tty/serial/8250/8250_core.c:440:2: error: implicit declaration of function 'ioread32be' [-Werror=implicit-function-declaration]
>      return ioread32be(p->membase + offset);
>      ^
>    cc1: some warnings being treated as errors
> 
> Compile-tested only.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 

Both patches

Acked-by: Arnd Bergmann <arnd@arndb.de>
