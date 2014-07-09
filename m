Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaGIU64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:58:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaGIU6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:58:55 -0400
Date: Wed, 9 Jul 2014 22:58:50 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: IEEE 1394 (FireWire) support should depend on
 HAS_DMA
Message-ID: <20140709225850.57132656@endymion.delvare>
In-Reply-To: <1404932640-9029-1-git-send-email-geert@linux-m68k.org>
References: <1404932640-9029-1-git-send-email-geert@linux-m68k.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed,  9 Jul 2014 21:04:00 +0200, Geert Uytterhoeven wrote:
> Commit b3d681a4fc108f9653bbb44e4f4e72db2b8a5734 ("firewire: Use
> COMPILE_TEST for build testing") added COMPILE_TEST as an alternative
> dependency for the purpose of build testing the firewire core.
> However, this bypasses all other implicit dependencies assumed by PCI,
> like HAS_DMA.

Good catch, however the problem was already present before commit
b3d681a4, just less visible because nobody test builds with BROKEN. I'm
not even sure why we still have that, but that's a different story...

> 
> If NO_DMA=y:
> 
>     drivers/built-in.o: In function `fw_iso_buffer_destroy':
>     (.text+0x36a096): undefined reference to `dma_unmap_page'
>     drivers/built-in.o: In function `fw_iso_buffer_map_dma':
>     (.text+0x36a164): undefined reference to `dma_map_page'
>     drivers/built-in.o: In function `fw_iso_buffer_map_dma':
>     (.text+0x36a172): undefined reference to `dma_mapping_error'
>     drivers/built-in.o: In function `sbp2_send_management_orb':
>     sbp2.c:(.text+0x36c6b4): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36c6c8): undefined reference to `dma_mapping_error'
>     sbp2.c:(.text+0x36c772): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36c786): undefined reference to `dma_mapping_error'
>     sbp2.c:(.text+0x36c854): undefined reference to `dma_unmap_single'
>     sbp2.c:(.text+0x36c872): undefined reference to `dma_unmap_single'
>     drivers/built-in.o: In function `sbp2_map_scatterlist':
>     sbp2.c:(.text+0x36ccbc): undefined reference to `scsi_dma_map'
>     sbp2.c:(.text+0x36cd36): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36cd4e): undefined reference to `dma_mapping_error'
>     sbp2.c:(.text+0x36cd84): undefined reference to `scsi_dma_unmap'
>     drivers/built-in.o: In function `sbp2_unmap_scatterlist':
>     sbp2.c:(.text+0x36cda6): undefined reference to `scsi_dma_unmap'
>     sbp2.c:(.text+0x36cdc6): undefined reference to `dma_unmap_single'
>     drivers/built-in.o: In function `complete_command_orb':
>     sbp2.c:(.text+0x36d6ac): undefined reference to `dma_unmap_single'
>     drivers/built-in.o: In function `sbp2_scsi_queuecommand':
>     sbp2.c:(.text+0x36d8e0): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36d8f6): undefined reference to `dma_mapping_error'
> 
> Add an explicit dependency on HAS_DMA to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: Jean Delvare <jdelvare@suse.de>

> ---
>  drivers/firewire/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
> index 4199849e3758..145974f9662b 100644
> --- a/drivers/firewire/Kconfig
> +++ b/drivers/firewire/Kconfig
> @@ -1,4 +1,5 @@
>  menu "IEEE 1394 (FireWire) support"
> +	depends on HAS_DMA
>  	depends on PCI || COMPILE_TEST
>  	# firewire-core does not depend on PCI but is
>  	# not useful without PCI controller driver

Thanks,
-- 
Jean Delvare
SUSE L3 Support
