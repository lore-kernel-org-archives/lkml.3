Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbbAETKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:10:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:47612 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbbAETKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:10:23 -0500
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Thomas D <whissi@whissi.de>
CC: <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] tools/power: turbostat: Use $(CURDIR) instead of $(PWD) in Makefile
Date: Mon, 5 Jan 2015 14:11:41 -0500
Message-ID: <2779550.jOF2haXjUH@yow-masselst-d1>
Organization: Wind River Internation Inc.
User-Agent: KMail/4.13.3 (Linux/3.13.0-36-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1420393963-30645-1-git-send-email-whissi@whissi.de>
References: <1420393963-30645-1-git-send-email-whissi@whissi.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: [128.224.56.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 4, 2015 18:52:43 Thomas D wrote:
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
> guarantees to set and update (i.e. when using "make –C ...").
> 
> Link: https://bugs.gentoo.org/show_bug.cgi?id=533918
> Fixes: ee0778a30153 ("tools/power: turbostat: make Makefile a bit more
> capable") Signed-off-by: Thomas D. <whissi@whissi.de>
> Cc: Mark Asselstine <mark.asselstine@windriver.com>

Looks fine. I am wondering if we should take this opportunity to respect "O=" 
as the kernel does. ie. default to CURDIR but using whatever is passed in via 
O= on the cmdline.

Mark

> Cc: Len Brown <len.brown@intel.com>
> ---
>  tools/power/x86/turbostat/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/power/x86/turbostat/Makefile
> b/tools/power/x86/turbostat/Makefile index d1b3a36..6dd4cad 100644
> --- a/tools/power/x86/turbostat/Makefile
> +++ b/tools/power/x86/turbostat/Makefile
> @@ -1,5 +1,5 @@
>  CC		= $(CROSS_COMPILE)gcc
> -BUILD_OUTPUT	:= $(PWD)
> +BUILD_OUTPUT	:= $(CURDIR)
>  PREFIX		:= /usr
>  DESTDIR		:=
> 
> --
> 2.2.1

