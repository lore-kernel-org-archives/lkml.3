Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaICLXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:23:09 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:47914 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaICLXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:23:05 -0400
Date: Wed, 3 Sep 2014 13:22:58 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/38] cris: fix headers_install
Message-ID: <20140903112258.GQ27603@axis.com>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:08:29PM +0200, Sam Ravnborg wrote:
> Fix headers_install by adjusting the path to arch files.
> And delete unused Kbuild file.
> Drop special handling of cris in the headers.sh script as a nice side-effect.

Don't see this patch in Linus tree yet, so if you want it, here's my

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

and thanks!

> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/cris/include/asm/Kbuild      | 5 -----
>  arch/cris/include/uapi/asm/Kbuild | 4 ++--
>  scripts/headers.sh                | 2 --
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
> index afff510..35574f5 100644
> --- a/arch/cris/include/asm/Kbuild
> +++ b/arch/cris/include/asm/Kbuild
> @@ -1,8 +1,3 @@
> -
> -header-y += arch-v10/
> -header-y += arch-v32/
> -
> -
>  generic-y += barrier.h
>  generic-y += clkdev.h
>  generic-y += cputime.h
> diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
> index 7d47b36..01f66b8 100644
> --- a/arch/cris/include/uapi/asm/Kbuild
> +++ b/arch/cris/include/uapi/asm/Kbuild
> @@ -1,8 +1,8 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> -header-y += arch-v10/
> -header-y += arch-v32/
> +header-y += ../arch-v10/arch/
> +header-y += ../arch-v32/arch/
>  header-y += auxvec.h
>  header-y += bitsperlong.h
>  header-y += byteorder.h
> diff --git a/scripts/headers.sh b/scripts/headers.sh
> index 95ece06..d4dc4de 100755
> --- a/scripts/headers.sh
> +++ b/scripts/headers.sh
> @@ -19,8 +19,6 @@ for arch in ${archs}; do
>  	case ${arch} in
>  	um)        # no userspace export
>  		;;
> -	cris)      # headers export are known broken
> -		;;
>  	*)
>  		if [ -d ${srctree}/arch/${arch} ]; then
>  			do_command $1 ${arch}
> -- 
> 1.9.3

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
