Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbaDIOPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:15:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbaDIOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:15:00 -0400
Message-ID: <534555E2.6030506@suse.cz>
Date: Wed, 09 Apr 2014 16:14:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: suppress "Nothing to be done for ..." messages
References: <1397027753-15444-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1397027753-15444-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ccing x86 maintainers

On 2014-04-09 09:15, Masahiro Yamada wrote:
> When we compiled again, arch/x86/syscalls/Makefile and
> arch/x86/tools/Makefile emitted "Nothing to be done for ..." messages.
> 
> Here is the command log:
> 
>   $ make defconfig
>      [ snip ]
>   $ make
>      [ snip ]
>   $ make
>   make[1]: Nothing to be done for `all'.            <-----
>   make[1]: Nothing to be done for `relocs'.         <-----
>     CHK     include/config/kernel.release
>     CHK     include/generated/uapi/linux/version.h
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
>  arch/x86/syscalls/Makefile | 1 +
>  arch/x86/tools/Makefile    | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
> index f325af2..b6c923a 100644
> --- a/arch/x86/syscalls/Makefile
> +++ b/arch/x86/syscalls/Makefile
> @@ -56,3 +56,4 @@ targets	+= $(uapisyshdr-y) $(syshdr-y)
>  
>  all: $(addprefix $(uapi)/,$(uapisyshdr-y))
>  all: $(addprefix $(out)/,$(syshdr-y))
> +	@:

The "all" target should also be added to the PHONY variable.


> diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
> index e812034..95e3ed7 100644
> --- a/arch/x86/tools/Makefile
> +++ b/arch/x86/tools/Makefile
> @@ -41,3 +41,4 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
>  hostprogs-y	+= relocs
>  relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
>  relocs: $(obj)/relocs
> +	@:
> 

You can add Acked-by: Michal Marek <mmarek@suse.cz> if you want.

Michal
