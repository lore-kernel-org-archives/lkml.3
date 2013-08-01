Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3HAKG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:06:26 -0400
Received: from mail.southpole.se ([37.247.8.11]:44004 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab3HAKGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:06:24 -0400
Message-ID: <51FA2E77.1020809@southpole.se>
Date: Thu, 01 Aug 2013 11:46:31 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openrisc: Makefile: append "-D__linux__" to KBUILD_CFLAGS
References: <51F885C3.3040501@asianux.com>
In-Reply-To: <51F885C3.3040501@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13137) on assp.southpole.se
X-Assp-ID: assp.southpole.se 50292-07404
X-Assp-Session: 7F85AD896F58 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 05:34 AM, Chen Gang wrote:
> Need append "_D__linux__" to KBUILD_CFLAGS, just like some of another
> architectures have done, or 'allmodconfig' can not pass compiling.
>
> The related error:
>
>      CC [M]  fs/coda/psdev.o
>    In file included from include/linux/coda.h:65:0,
>                     from fs/coda/psdev.c:45:
>    include/uapi/linux/coda.h:221:2: error: expected specifier-qualifier-list before 'u_quad_t'
>
> The related compiler information:
>
>    [root@dhcp122 ~]# /usr/local/bin/or32-linux-gcc -v
>    Using built-in specs.
>    COLLECT_GCC=/usr/local/bin/or32-linux-gcc
>    COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/or32-linux/4.5.1-or32-1.0rc1/lto-wrapper
>    Target: or32-linux
>    Configured with: ../gcc-openrisc/configure --target=or32-linux --disable-nls --enable-languages=c --without-headers --disable-shared --disable-threads --enable-werror=no
>    Thread model: single
>    gcc version 4.5.1-or32-1.0rc1 (GCC)
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Thanks.  Applied.
/Jonas

> ---
>   arch/openrisc/Makefile |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/openrisc/Makefile b/arch/openrisc/Makefile
> index 4739b83..89076a6 100644
> --- a/arch/openrisc/Makefile
> +++ b/arch/openrisc/Makefile
> @@ -24,7 +24,7 @@ OBJCOPYFLAGS    := -O binary -R .note -R .comment -S
>   LDFLAGS_vmlinux :=
>   LIBGCC 		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
>
> -KBUILD_CFLAGS	+= -pipe -ffixed-r10
> +KBUILD_CFLAGS	+= -pipe -ffixed-r10 -D__linux__
>
>   ifeq ($(CONFIG_OPENRISC_HAVE_INST_MUL),y)
>   	KBUILD_CFLAGS += $(call cc-option,-mhard-mul)
>

