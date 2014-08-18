Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaHRGfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:35:39 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44168 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaHRGfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:35:37 -0400
MIME-Version: 1.0
In-Reply-To: <1408335898-3109-1-git-send-email-bobby.prani@gmail.com>
References: <1408335898-3109-1-git-send-email-bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 10:35:36 +0400
Message-ID: <CAMo8Bf++rGnUkeOy3_gCimv9moStOx+fOtGAAeCXT8Hz2RsvBg@mail.gmail.com>
Subject: Re: [PATCH] flush_icache_range: Export symbol to fix build errors
From: Max Filippov <jcmvbkbc@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>, Steven Miao <realmz6@gmail.com>,
        David Howells <dhowells@redhat.com>, Richard Kuo <rkuo@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        Noam Camus <noamc@ezchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tony Lu <zlu@tilera.com>, Kirill Tkhai <tkhai@yandex.ru>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BLACKFIN ARCHITEC..." 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>,
        "open list:METAG ARCHITECTURE" <linux-metag@vger.kernel.org>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        "open list:TENSILICA XTENSA..." <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Mon, Aug 18, 2014 at 8:24 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Fix building errors occuring due to a missing export of flush_icache_range() in
> architectures missing the export.

Can you be a little more specific here, what build errors?

[...]

> diff --git a/arch/frv/include/asm/cacheflush.h b/arch/frv/include/asm/cacheflush.h
> index edbac54..07ee4b3 100644
> --- a/arch/frv/include/asm/cacheflush.h
> +++ b/arch/frv/include/asm/cacheflush.h
> @@ -72,6 +72,7 @@ static inline void flush_icache_range(unsigned long start, unsigned long end)
>  {
>         frv_cache_wback_inv(start, end);
>  }
> +EXPORT_SYMBOL(flush_icache_range);

EXPORT_SYMBOL should not be placed into header file as it defines
a non-static variable.

[...]

> diff --git a/arch/metag/include/asm/cacheflush.h b/arch/metag/include/asm/cacheflush.h
> index 7787ec5..117c212 100644
> --- a/arch/metag/include/asm/cacheflush.h
> +++ b/arch/metag/include/asm/cacheflush.h
> @@ -124,6 +124,7 @@ static inline void flush_icache_range(unsigned long address,
>         metag_code_cache_flush((void *) address, endaddr - address);
>  #endif
>  }
> +EXPORT_SYMBOL(flush_icache_range);

Same here.

-- 
Thanks.
-- Max
