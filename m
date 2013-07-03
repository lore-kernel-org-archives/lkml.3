Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3GCUuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:50:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131Ab3GCUt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:49:59 -0400
Message-ID: <51D48E72.5010403@suse.cz>
Date: Wed, 03 Jul 2013 22:49:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?5byg5b+g5bGx?= <zzs0213@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] let kbuild mkdir for dir/file.o
References: <51CE11C2.5020406@suse.cz> <1372583368-32618-1-git-send-email-zzs0213@gmail.com>
In-Reply-To: <1372583368-32618-1-git-send-email-zzs0213@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 30.6.2013 11:09, 张忠山 napsal(a):
> When add a obj with dir to obj-y, like this
> 
>     obj-y += dir/file.o
> 
> The $(obj)/dir not created, this patch fix this.
> 
> When try to add a file(which in a subdir) to my board's obj-y, the build
> progress crashed.
> 
> For example, I use at91rm9200ek board, and in kernel dir run:
> 
>   mkdir objtree
>   make O=objtree at91rm9200_defconfig
>   mkdir arch/arm/mach-at91/dir
>   touch arch/arm/mach-at91/dir/file.c
> 
> and edit arch/arm/mach-at91/dir/file.c to add some code.
> then edit arch/arm/mach-at91/Makefile, change the following line:
> 
>   obj-$(CONFIG_MACH_AT91RM9200EK) += board-rm9200ek.o
> 
> to:
> 
>   obj-$(CONFIG_MACH_AT91RM9200EK) += board-rm9200ek.o dir/file.o
> 
> Now build it:
> 
>   make O=objtree
> 
> Then the error appears:
>   ...
>   CC      arch/arm/mach-at91/board-rm9200dk.o
>   CC      arch/arm/mach-at91/board-rm9200ek.o
>   CC      arch/arm/mach-at91/dir/file.o
>   linux-2.6/arch/arm/mach-at91/dir/file.c:5:
>     fatal error: opening dependency file
>     arch/arm/mach-at91/dir/.file.o.d: No such file or directory
> 
> Check the objtree:
>   LANG=en ls objtree/arch/arm/mach-at91/dir
>   ls: cannot access objtree/arch/arm/mach-at91/dir: No such file or directory
> 
> It's apparently that the target dir not created for file.o
> 
> Check kbuild source code. It seems that kbuild create dirs for that in
> $(obj-dirs).  But if the dir need not to create a built-in.o, It should
> never in  $(obj-dirs).
> 
> So I make this patch to make sure It in  $(obj-dirs)
> 
> this bug caused by commit
>    f5fb976520a53f45f8bbf2e851f16b3b5558d485
> ---

You forgot to sign off this patch, can I add

  Signed-off-by: 张忠山 <zzs0213@gmail.com>

like you did in the previous versions? Otherwise, the patch looks OK.

Michal
