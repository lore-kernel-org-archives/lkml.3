Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3IEQCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:02:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46691 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab3IEQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:02:01 -0400
Message-ID: <1378396919.2142.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] parisc: Export flush_cache_page() (needed by lustre)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Sep 2013 09:01:59 -0700
In-Reply-To: <1378373595-29471-1-git-send-email-geert@linux-m68k.org>
References: <1378373595-29471-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 11:33 +0200, Geert Uytterhoeven wrote:
> ERROR: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/parisc/kernel/cache.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
> index c035673..b521c0a 100644
> --- a/arch/parisc/kernel/cache.c
> +++ b/arch/parisc/kernel/cache.c
> @@ -602,6 +602,7 @@ flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr, unsigned long
>  		__flush_cache_page(vma, vmaddr, PFN_PHYS(pfn));
>  	}
>  }
> +EXPORT_SYMBOL_GPL(flush_cache_page);

This is an internal API: no architecture exports this.  Whoever is
trying to use it needs to use the correct API, so this is the wrong
patch.

James


