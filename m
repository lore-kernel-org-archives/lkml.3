Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaFOEjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 00:39:23 -0400
Received: from mail-ve0-f193.google.com ([209.85.128.193]:39747 "EHLO
	mail-ve0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaFOEjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 00:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <1402805139-6363-1-git-send-email-xerofoify@gmail.com>
References: <1402805139-6363-1-git-send-email-xerofoify@gmail.com>
Date: Sun, 15 Jun 2014 00:39:21 -0400
Message-ID: <CAPDOMVhAZvh5SDB0E4BRhEnuJm0OksdAjHWxCKphagZuohqbqw@mail.gmail.com>
Subject: Re: [PATCH] Missing return check against Null for return value of netdev_alloc_dev_skb()
From: Nick Krause <xerofoify@gmail.com>
To: davem@davemloft.net
Cc: andriy.shevchenko@linux.intel.com, dvhart@linux.intel.com,
        jeffrey.t.kirsher@intel.com, ast@plumgrid.com, dborkman@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bwh@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending this patch as the email for Ben is wrong in the
maintainer script due to getting automated message from solarflare.
Signed-off-by: Nick <xerofoify@gmail.com>
---
 drivers/net/ethernet/oki-semi/
pch_gbe/pch_gbe_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 73e6683..704cf63 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1515,6 +1515,8 @@ static void pch_gbe_alloc_tx_buffers(struct
pch_gbe_adapter *adapter,
        for (i = 0; i < tx_ring->count; i++) {
                buffer_info = &tx_ring->buffer_info[i];
                skb = netdev_alloc_skb(adapter->netdev, bufsz);
+               if (!skb)
+                       return NULL;
                skb_reserve(skb, PCH_GBE_DMA_ALIGN);
                buffer_info->skb = skb;
                tx_desc = PCH_GBE_TX_DESC(*tx_ring, i);
Thanks Nick

On Sun, Jun 15, 2014 at 12:05 AM, Nick <xerofoify@gmail.com> wrote:
> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> index 73e6683..704cf63 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> @@ -1515,6 +1515,8 @@ static void pch_gbe_alloc_tx_buffers(struct pch_gbe_adapter *adapter,
>         for (i = 0; i < tx_ring->count; i++) {
>                 buffer_info = &tx_ring->buffer_info[i];
>                 skb = netdev_alloc_skb(adapter->netdev, bufsz);
> +               if (!skb)
> +                       return NULL;
>                 skb_reserve(skb, PCH_GBE_DMA_ALIGN);
>                 buffer_info->skb = skb;
>                 tx_desc = PCH_GBE_TX_DESC(*tx_ring, i);
> --
> 1.9.1
>
