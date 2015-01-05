Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbbAEUxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:53:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:34900 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbbAEUxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:53:09 -0500
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Thomas D <whissi@whissi.de>
CC: <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] tools/power: turbostat: Use $(CURDIR) instead of $(PWD) in Makefile
Date: Mon, 5 Jan 2015 15:54:27 -0500
Message-ID: <4243613.D4Ur32Y8Gy@yow-masselst-d1>
Organization: Wind River Internation Inc.
User-Agent: KMail/4.13.3 (Linux/3.13.0-36-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1420490243-15375-1-git-send-email-whissi@whissi.de>
References: <2779550.jOF2haXjUH@yow-masselst-d1> <1420490243-15375-1-git-send-email-whissi@whissi.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: [128.224.56.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 5, 2015 21:37:23 Thomas D wrote:
> [PATCH] tools/power: turbostat: Use $(CURDIR) instead of $(PWD) and
>  add support for O= option in Makefil
> 
> Since commit ee0778a30153 ("tools/power: turbostat: make Makefile a bit
> more capable") turbostat’s Makefile is using
> 
>   [...]
>   BUILD_OUTPUT    := $(PWD)
>   [...]
> 
> which obviously causes trouble when building "turbostat" with
> 
>   make -C /usr/src/linux/tools/power/x86/turbostat ARCH=x86 turbostat
> 
> because GNU make doesn’t update nor guarantee that $PWD is set.
> 
> This patch changes the Makefile to use $CURDIR instead, which GNU make
> guarantees to set and update (i.e. when using "make –C ...") and also
> adds support for the O= option (see "make help" in your root of your
> kernel source tree for more details).
> 
> Link: https://bugs.gentoo.org/show_bug.cgi?id=533918
> Fixes: ee0778a30153 ("tools/power: turbostat: make Makefile a bit more
> capable") Signed-off-by: Thomas D. <whissi@whissi.de>
> Cc: Mark Asselstine <mark.asselstine@windriver.com>
> Cc: Len Brown <len.brown@intel.com>
> ---
>  I followed Mark's suggestion and also added support for the O= option.
>  I took the logic from tools/power/cpupower/Makefile.
> 
>  ...i also hope this reply will work and doesn't break the tread ;)

Looks OK to me. You could have always started a new 'v2' thread with '[PATCH 
v2]' so no worries.

Mark

> 
>  tools/power/x86/turbostat/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/power/x86/turbostat/Makefile
> b/tools/power/x86/turbostat/Makefile index d1b3a36..4039854 100644
> --- a/tools/power/x86/turbostat/Makefile
> +++ b/tools/power/x86/turbostat/Makefile
> @@ -1,8 +1,12 @@
>  CC		= $(CROSS_COMPILE)gcc
> -BUILD_OUTPUT	:= $(PWD)
> +BUILD_OUTPUT	:= $(CURDIR)
>  PREFIX		:= /usr
>  DESTDIR		:=
> 
> +ifeq ("$(origin O)", "command line")
> +	BUILD_OUTPUT := $(O)
> +endif
> +
>  turbostat : turbostat.c
>  CFLAGS +=	-Wall
>  CFLAGS +=	-DMSRHEADER='"../../../../arch/x86/include/uapi/asm/msr-
index.h"'
> --
> 2.2.1

