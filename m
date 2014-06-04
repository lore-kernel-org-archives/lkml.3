Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaFDJD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:03:58 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60653 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaFDJDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1399639944-20551-4-git-send-email-mmarek@suse.cz>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
	<1399639944-20551-4-git-send-email-mmarek@suse.cz>
Date: Wed, 4 Jun 2014 11:03:54 +0200
Message-ID: <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, rdunlap@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 2:52 PM, Michal Marek <mmarek@suse.cz> wrote:
> The main Makefile sets its working directory to the object tree and
> never changes it again. Therefore, we can use '.' instead of the
> absolute path. The only case where we need the absolute path is when
> creating the 'build' symlink in /lib/modules.
>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> v1->v2: Fix the 'build' symlink
>
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 60ccbfe..480503a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -154,7 +154,7 @@ _all: modules
>  endif
>
>  srctree                := $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
> -objtree                := $(CURDIR)
> +objtree                := .
>  src            := $(srctree)
>  obj            := $(objtree)
>
> @@ -1057,7 +1057,7 @@ _modinst_:
>         @ln -s $(srctree) $(MODLIB)/source
>         @if [ ! $(objtree) -ef  $(MODLIB)/build ]; then \
>                 rm -f $(MODLIB)/build ; \
> -               ln -s $(objtree) $(MODLIB)/build ; \
> +               ln -s $(CURDIR) $(MODLIB)/build ; \
>         fi
>         @cp -f $(objtree)/modules.order $(MODLIB)/
>         @cp -f $(objtree)/modules.builtin $(MODLIB)/

This commit breaks the of-of-tree build of UML.

  CC      arch/x86/um/user-offsets.s
/home/rw/linux-next/arch/x86/um/user-offsets.c:21:29: fatal error:
asm/syscalls_64.h: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/um/user-offsets.s] Error 1
make[1]: *** [arch/x86/um/user-offsets.s] Error 2
make: *** [sub-make] Error 2

To reproduce run:
make defconfig ARCH=um O=/mnt/o && make linux ARCH=um O=/mnt/

If there is anything in UML which needs fixing, please tell. :-)

-- 
Thanks,
//richard
