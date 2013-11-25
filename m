Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3KYJzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:55:20 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53660 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab3KYJzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:55:18 -0500
Message-ID: <1385373313.2354.16.camel@dabdike>
Subject: Re: [PATCH 08/24] parisc/uapi: Use Kbuild logic to provide
 <asm/types.h>
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Date: Mon, 25 Nov 2013 13:55:13 +0400
In-Reply-To: <1385369734-24893-9-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
	 <1385369734-24893-9-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 09:55 +0100, Geert Uytterhoeven wrote:
> Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>

This really doesn't look like a good idea:  Firstly the default of
asm-generic/types.h should *not* be int-ll64, because that's for 32 bit
only and most processors are moving towards 64 bit.  Secondly parisc
currently only has a 32 bit userspace, which is why the file is a simple
include of int-ll64.h; however, people are working on 64 bit userspace
(albeit very slowly) and that file would then have to change.  If we
take the file away someone will forget to add the changed file back.

James


> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-parisc@vger.kernel.org
> ---
>  arch/parisc/include/uapi/asm/Kbuild  |    3 ++-
>  arch/parisc/include/uapi/asm/types.h |    6 ------
>  2 files changed, 2 insertions(+), 7 deletions(-)
>  delete mode 100644 arch/parisc/include/uapi/asm/types.h
> 
> diff --git a/arch/parisc/include/uapi/asm/Kbuild b/arch/parisc/include/uapi/asm/Kbuild
> index a580642555b6..e0da93254186 100644
> --- a/arch/parisc/include/uapi/asm/Kbuild
> +++ b/arch/parisc/include/uapi/asm/Kbuild
> @@ -1,6 +1,8 @@
>  # UAPI Header export list
>  include include/uapi/asm-generic/Kbuild.asm
>  
> +generic-y += types.h
> +
>  header-y += bitsperlong.h
>  header-y += byteorder.h
>  header-y += errno.h
> @@ -27,5 +29,4 @@ header-y += statfs.h
>  header-y += swab.h
>  header-y += termbits.h
>  header-y += termios.h
> -header-y += types.h
>  header-y += unistd.h
> diff --git a/arch/parisc/include/uapi/asm/types.h b/arch/parisc/include/uapi/asm/types.h
> deleted file mode 100644
> index 8866f9bbdeaf..000000000000
> --- a/arch/parisc/include/uapi/asm/types.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _PARISC_TYPES_H
> -#define _PARISC_TYPES_H
> -
> -#include <asm-generic/int-ll64.h>
> -
> -#endif



