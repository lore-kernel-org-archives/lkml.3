Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3L3Jo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:44:27 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33139 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3L3JoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:44:25 -0500
MIME-Version: 1.0
In-Reply-To: <1388386511-32276-1-git-send-email-baozich@gmail.com>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com>
From: Wei Liu <liuw@liuw.name>
Date: Mon, 30 Dec 2013 09:43:54 +0000
Message-ID: <CAOsiSVWe7zRL2qmExHL3D4ayYyHmzHU=PonQ+-Q625Vkji+J4A@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] arm64/xen: redefine xen_remap on arm64
To: Chen Baozi <baozich@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        xen-devel <xen-devel@lists.xenproject.org>, catalin.marinas@arm.com,
        msalter@redhat.com, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 6:55 AM, Chen Baozi <baozich@gmail.com> wrote:
> xen_remap used to be defined as ioremap_cached on arm64. In commit
> c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
> was deleted, while xen_remap stays the same. This would lead to
> the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
> on arm64 as ioremap_cache on arm64 to fix it.
>
> Signed-off-by: Chen Baozi <baozich@gmail.com>
> ---
>  arch/arm/include/asm/xen/page.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index 75579a9..b3368df 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -117,6 +117,10 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>         return __set_phys_to_machine(pfn, mfn);
>  }
>
> +#ifdef CONFIG_ARM64
> +#define xen_remap(cookie, size) ioremap_cache((cookie), (size))
> +#else
>  #define xen_remap(cookie, size) ioremap_cached((cookie), (size));

Looks like there's an redundant semicolon in the original implementation.

Wei.

> +#endif
>
>  #endif /* _ASM_ARM_XEN_PAGE_H */
> --
> 1.8.4.3
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
