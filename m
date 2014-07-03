Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaGCVM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:12:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbaGCVMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:12:24 -0400
Message-ID: <53B5C734.9020507@suse.cz>
Date: Thu, 03 Jul 2014 23:12:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Woodhouse <dwmw2@infradead.org>, Rob Landley <rob@landley.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Documentation/make/headers_install.txt: update documentation
References: <1404155479-5638-1-git-send-email-ydroneaud@opteya.com>
In-Reply-To: <1404155479-5638-1-git-send-email-ydroneaud@opteya.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 30.6.2014 21:11, Yann Droneaud napsal(a):
> Documentation in make/headers_install.txt is not
> up to date regarding:
> - way to list the various architectures;
> - path where the headers are installed.
> 
> This patch try to fix these issues.
> 
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>  Documentation/make/headers_install.txt | 15 ++++++++-------

I have never noticed this file :). How about moving it to
Documentation/kbuild?


>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/make/headers_install.txt b/Documentation/make/headers_install.txt
> index 951eb9f1e040..8b6751f10dd3 100644
> --- a/Documentation/make/headers_install.txt
> +++ b/Documentation/make/headers_install.txt
> @@ -24,23 +24,24 @@ The "make headers_install" command can be run in the top level directory of the
>  kernel source code (or using a standard out-of-tree build).  It takes two
>  optional arguments:
>  
> -  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
> +  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr

ARCH=x86 maybe?


>  ARCH indicates which architecture to produce headers for, and defaults to the
> -current architecture.  The linux/asm directory of the exported kernel headers
> -is platform-specific, to see a complete list of supported architectures use
> +current architecture.  The asm/ directory of the exported kernel headers
> +is platform-specific, to see a list of supported architectures use
>  the command:
>  
> -  ls -d include/asm-* | sed 's/.*-//'
> +  /bin/ls -1 arch/*/include/asm/Kbuild | sed -e 's,^arch/,,' \
> +                                             -e 's,/include/asm/Kbuild$,,'

Or, more simply, 'ls arch/'.


> -INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
> -"./usr/include".
> +INSTALL_HDR_PATH indicates where to create include/ directory to install the
> +headers. It defaults to "./usr/".
>  
>  The command "make headers_install_all" exports headers for all architectures
>  simultaneously.  (This is mostly of interest to distribution maintainers,
>  who create an architecture-independent tarball from the resulting include
>  directory.)  You also can use HDR_ARCH_LIST to specify list of architectures.
> -Remember to provide the appropriate linux/asm directory via "mv" or "ln -s"
> +Remember to provide the appropriate asm/ directory via "mv" or "ln -s"
>  before building a C library with headers exported this way.
>  
>  The kernel header export infrastructure is maintained by David Woodhouse
> 

Looks good,

Thanks,
Michal
