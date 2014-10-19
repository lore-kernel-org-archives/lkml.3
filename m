Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaJSW3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:29:41 -0400
Received: from mta-out1.inet.fi ([62.71.2.234]:39257 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaJSW3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:29:38 -0400
Date: Mon, 20 Oct 2014 01:29:28 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
Message-ID: <20141019222928.GA9319@node.dhcp.inet.fi>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 12:07:42PM -0400, Sasha Levin wrote:
> gcc5 changes the default standard to c11, rather than gnu89, which
> makes kernel build unhappy.
> 
> Explicitly define the kernel standard to be gnu89 which should
> keep everything working exactly like it was before gcc5.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  Makefile |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index dd7e1cb..43f31cb 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -642,7 +642,8 @@ ifdef CONFIG_READABLE_ASM
>  # partial inlining inlines only parts of functions
>  KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
>                   $(call cc-option,-fno-ipa-cp-clone,) \
> -                 $(call cc-option,-fno-partial-inlining)
> +                 $(call cc-option,-fno-partial-inlining,) \
> +                 $(call cc-option,-std=gnu89)
>  endif

Hm. Why is that under #ifdef CONFIG_READABLE_ASM ?

-- 
 Kirill A. Shutemov
