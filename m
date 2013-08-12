Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3HLNiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:38:25 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54220 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab3HLNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:38:23 -0400
MIME-Version: 1.0
In-Reply-To: <1373803321-11628-2-git-send-email-gsi@denx.de>
References: <1373642781-32631-1-git-send-email-gsi@denx.de>
	<1373803321-11628-1-git-send-email-gsi@denx.de>
	<1373803321-11628-2-git-send-email-gsi@denx.de>
Date: Mon, 12 Aug 2013 17:38:21 +0400
Message-ID: <CAF0T0X4f9RCjY-tyw9z+X_n7qRxXacKf7FOzT-U_rH0WtLOUHw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/5] dma: mpc512x: re-order mpc8308 specific instructions
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

2013/7/14 Gerhard Sittig <gsi@denx.de>:
> @@ -50,9 +50,23 @@
>  #define MPC_DMA_DESCRIPTORS    64
>
>  /* Macro definitions */
> -#define MPC_DMA_CHANNELS       64
>  #define MPC_DMA_TCD_OFFSET     0x1000
>
> +/*
> + * the maximum channel count, and specific channels which need
> + * special processing, for individual hardware variants
> + *
> + * and the maximum channel count over all supported controllers,
> + * used for data structure sizes
> + */
> +enum mpc8308_dmachan_id_t {
> +       MPC8308_DMACHAN_MAX = 16,
> +};
> +enum mpc512x_dmachan_id_t {
> +       MPC512x_DMACHAN_MAX = 64,
> +};
> +#define MPC_DMA_CHANNELS       64
> +

I offer to use #define instead of enum here
since individual channels don't require special handling.

Best regards,
Alexander.
