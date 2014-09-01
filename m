Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaIAIV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:21:58 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:12330 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:21:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,440,1406617200"; 
   d="scan'208";a="44051744"
Message-ID: <54042CA1.6010904@broadcom.com>
Date: Mon, 1 Sep 2014 10:21:53 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: BRCMFMAC should depend on HAS_DMA
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/14 18:24, Geert Uytterhoeven wrote:
> If NO_DMA=y:
>
> drivers/built-in.o: In function `brcmf_msgbuf_release_array':
> msgbuf.c:(.text+0x34dbbe): undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `brcmf_proto_msgbuf_detach':
> (.text+0x34dca4): undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `brcmf_msgbuf_get_pktid':
> msgbuf.c:(.text+0x34dd2a): undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `brcmf_msgbuf_alloc_pktid':
> msgbuf.c:(.text+0x34de12): undefined reference to `dma_map_single'
> msgbuf.c:(.text+0x34de20): undefined reference to `dma_mapping_error'
> drivers/built-in.o: In function `brcmf_msgbuf_remove_flowring':
> msgbuf.c:(.text+0x34e3d6): undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `brcmf_msgbuf_flowring_create':
> msgbuf.c:(.text+0x34e4f8): undefined reference to `dma_alloc_coherent'
> drivers/built-in.o: In function `brcmf_proto_msgbuf_attach':
> (.text+0x34f5fe): undefined reference to `dma_alloc_coherent'
> drivers/built-in.o: In function `brcmf_proto_msgbuf_attach':
> (.text+0x34f798): undefined reference to `dma_free_coherent'
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
> ---
>   drivers/net/wireless/brcm80211/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
> index b8e2561ea645..2e0da8925834 100644
> --- a/drivers/net/wireless/brcm80211/Kconfig
> +++ b/drivers/net/wireless/brcm80211/Kconfig
> @@ -19,7 +19,7 @@ config BRCMSMAC
>
>   config BRCMFMAC
>   	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
> -	depends on CFG80211
> +	depends on CFG80211A&&  HAS_DMA

Hi Geert,

Not sure what happened here, but CFG80211 kconfig option did was not 
renamed as far as I know. Anyway, I would like to propose a different 
solution. Will get back to you when I have it ready.

Regards,
Arend

>   	select BRCMUTIL
>   	---help---
>   	  This module adds support for embedded wireless adapters based on

