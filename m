Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3EMTQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:16:09 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48183 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3EMTQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <1368472300.3305.39.camel@bwh-desktop.uk.solarflarecom.com>
References: <1368467297.3305.28.camel@bwh-desktop.uk.solarflarecom.com>
	<CAMuHMdXnp0z-Tn6KBkPzpbmu1jFpZZaSWRGSggysX5QHNx52ng@mail.gmail.com>
	<1368472300.3305.39.camel@bwh-desktop.uk.solarflarecom.com>
Date: Mon, 13 May 2013 21:16:06 +0200
X-Google-Sender-Auth: UhKdEzifVf-lpCCJ_ur-F9zjG_U
Message-ID: <CAMuHMdVs+gcuGKdW82g+rkrzo53UGn0zqU8KwsThCY8STwCd0Q@mail.gmail.com>
Subject: Re: [PATCH net] sfc: Reduce RX scatter buffer size to multiple of 256
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 9:11 PM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
>> error: BUILD_BUG_ON failed: sizeof(struct efx_rx_page_state) +
>> EFX_PAGE_IP_ALIGN + EFX_RX_USR_BUF_SIZE > PAGE_SIZE / 2
>> make[4]: *** [drivers/net/ethernet/sfc/efx.o] Error 1
>
> OK, this doesn't work because on s390 EFX_PAGE_IP_ALIGN == 2 (this macro

Yeah, that's what I just discovered, too.

#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
#define EFX_PAGE_IP_ALIGN 0
#else
#define EFX_PAGE_IP_ALIGN NET_IP_ALIGN
#endif

> is equivalent to NET_IP_ALIGN, though that wasn't always true).  So DMA
> is going to be misaligned on s390 anyway.

Hmm, so it's making the choice between misaligned CPU and misaligned
DMA? Sounds fishy...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
