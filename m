Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaH2SSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:18:20 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58117 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaH2SSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:18:17 -0400
X-IronPort-AV: E=Sophos;i="5.04,425,1406617200"; 
   d="scan'208";a="43853533"
Message-ID: <5400C3E8.9040500@broadcom.com>
Date: Fri, 29 Aug 2014 11:18:16 -0700
From: Franky Lin <frankyl@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: BRCMFMAC should depend on HAS_DMA
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 8/29/2014 9:24 AM, Geert Uytterhoeven wrote:
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
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
> +	depends on CFG80211A && HAS_DMA
>   	select BRCMUTIL
>   	---help---
>   	  This module adds support for embedded wireless adapters based on

Thanks for reporting this. All complaints are from msgbuf code. So the 
dependency should belong to BRCMFMAC_PCIE not BRCMFMAC.

Thanks,
Franky
