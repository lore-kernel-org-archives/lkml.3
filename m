Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaGQTln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:41:43 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:30903 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbaGQTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:41:40 -0400
X-CheckPoint: {53C826F3-A-2100090A-C0000000}
Message-ID: <53C826F3.4030302@tilera.com>
Date: Thu, 17 Jul 2014 15:41:39 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 05/38] tile: clean up Kbuild files
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-5-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-5-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 11:08 AM, Sam Ravnborg wrote:
> Drop an unused Kbuild file - it was anyway empty
> Drop an irrelevent assignment to header-y
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>   arch/tile/include/arch/Kbuild | 1 -
>   arch/tile/include/asm/Kbuild  | 3 ---
>   2 files changed, 4 deletions(-)
>   delete mode 100644 arch/tile/include/arch/Kbuild
>
> diff --git a/arch/tile/include/arch/Kbuild b/arch/tile/include/arch/Kbuild
> deleted file mode 100644
> index 3751c9f..0000000
> --- a/arch/tile/include/arch/Kbuild
> +++ /dev/null
> @@ -1 +0,0 @@
> -# Tile arch headers

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

for this piece.  David Howells left these with just comments originally,
but removing the file entirely seems fine too.

> diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
> index 0aa5675..3013a07 100644
> --- a/arch/tile/include/asm/Kbuild
> +++ b/arch/tile/include/asm/Kbuild
> @@ -1,6 +1,3 @@
> -
> -header-y += ../arch/
> -
>   generic-y += bug.h
>   generic-y += bugs.h
>   generic-y += clkdev.h

Nack for this patch.  The arch/ headers are all intended to be shared by the
kernel and userspace, so we install them from the kernel.  This one header-y
line installs the 16 header files in usr/include/arch/*.h.  If there's a
better way to make that happen, that would be fine too, of course.

Arguably we could provide them separately (a tarball from tilera.com or
something) but frankly, this just makes the standard build flows for kernel,
gcc, and glibc more non-standard for tile, which seems like a bad thing.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

