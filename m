Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3FTERm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:17:42 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55967 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3FTERk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:17:40 -0400
Date: Wed, 19 Jun 2013 23:17:37 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Need to Test lld3 examples
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1371544794.13366.YahooMailNeo@web163905.mail.gq1.yahoo.com>
	(from sukiburyani@yahoo.com on Tue Jun 18 03:39:54 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371701857.2776.129@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 03:39:54 AM, Suki Buryani wrote:
> 
> 
> hi,
> 
> i am almost fresh in embedded Linux, i

http://kernelnewbies.org is the community's "where do I start" website.  
They have mentoring programs that are likely to provide more attention  
than you'll get here.

> want to test LDD3 examples, for that i install fedora 4 in my VM, i am
> unable to compile the kernel, i have set configs using make  
> menuconfig,
> and then try to make compile but it gives me  errors like
> 
> [root@localhost 2.6.11-1.1369_FC4-i686]# make

2.6.11. Huh. Quarterly releases, 3.0 would have been 2.6.40, we're now  
up to 3.10, so 39 releases ago...

That's almost a decade old. No idea, it could be anything...

>   CHK     include/linux/version.h
> scripts/kconfig/conf -s arch/i386/Kconfig

You didn't say which kernel version you were trying to build. If it's  
2.6.11, most of us aren't going to remember the details it was so long  
ago.

> #
> # using defaults found in .config
> #
>   SPLIT   include/linux/autoconf.h -> include/config/*
>   CHK     include/asm-i386/asm_offsets.h
>   CC      scripts/mod/empty.o
>   MKELF   scripts/mod/elfconfig.h
...
> scripts/mod/sumversion.c: In function 'maybe_frob_rcs_version':
> scripts/mod/sumversion.c:496: warning: pointer targets in passing  
> argument 1 of 'strip_rcs_crap' differ in signedness
>   HOSTLD  scripts/mod/modpost
> make[1]: *** No rule to make target `init/main.o', needed by  
> `init/built-in.o'.  Stop.
> make: *** [init] Error 2

Sounds like your version of "make" is too old? The file  
Documentation/Changes in the kernel source lists the minimum tool  
versions, and I vaguely recall there was a make bug requiring a version  
upgrade in the past 10 years...

Yeah, 4 years ago:

commit 2185a5ecd98d2cebc6a29b07b1ea4f7334c2ccc3
Author: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Date:   Sun Jun 14 22:38:59 2009 +0200

     documentation: make version fix

     The Makefiles in the build directories use the internal make  
variable
     MAKEFILE_LIST which is available from make 3.80 only.  (The patch  
would be
     valid back to 2.6.25)

     Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Possibly the version of make in the 10 year old distro is too old?

Rob