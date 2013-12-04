Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3LDSDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:03:30 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:47599 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3LDSD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:03:29 -0500
Date: Wed, 4 Dec 2013 18:03:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 07/10] ASoC: ux500: Store DMA data in the DAI differently
 in the pdata and DT case
Message-ID: <20131204180321.GE26581@lee--X1>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
 <CAGa+x85c3y5+VXFjHAZYpUM0+2Tfnra6QKad7-aeUdwjSwo+Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGa+x85c3y5+VXFjHAZYpUM0+2Tfnra6QKad7-aeUdwjSwo+Vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's next (next-20131204) has a new boot failure[1] on
> ux500/snowball which bisected down to this commit.  Full boot log
> attached.

Right.

Anyone not on CC (which I think you are Kevin) can follow the fun here:
  http://www.spinics.net/lists/arm-kernel/msg291374.html

> It doesn't find the alsa device which in turn seems to prevent the
> emmc rootfs from being mounted.  It boots fine to an initramfs.

<snip>

> of_dma_request_slave_channel: dma-names property of node '/soc/msp@80124000' missing or empty
> of_dma_request_slave_channel: dma-names property of node '/soc/msp@80124000' missing or empty
> of_dma_request_slave_channel: dma-names property of node '/soc/msp@80125000' missing or empty
> mmc1: new high speed MMC card at address 0001
> of_dma_request_slave_channel: dma-names property of node '/soc/msp@80125000' missing or empty
> mmcblk0: mmc1:0001  7.28 GiB 
> mmcblk0boot0: mmc1:0001  partition 1 2.00 MiB
> mmcblk0boot1: mmc1:0001  partition 2 2.00 MiB
> mmcblk0rpmb: mmc1:0001  partition 3 128 KiB
> dma dma0chan22: [d40_config_memcpy] No memcpy
> dma dma0chan22: [d40_alloc_chan_resources] Failed to configure memcpy channel
> ux500-msp-i2s ux500-msp-i2s.1: Missing dma channel for stream: 0
> ux500-msp-i2s ux500-msp-i2s.1: ASoC: pcm constructor failed: -22
> snd-soc-mop500 snd-soc-mop500.0: ASoC: can't create pcm ab8500_0 :-22
> snd-soc-mop500 snd-soc-mop500.0: ASoC: failed to instantiate card -22
> snd-soc-mop500 snd-soc-mop500.0: Error: snd_soc_register_card failed (-22)!
> snd-soc-mop500: probe of snd-soc-mop500.0 failed with error -22

<snip>

> mmci-pl18x sdi4: error during DMA transfer!
> mmcblk0rpmb: error -110 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
> mmcblk0rpmb: retrying using single block read

It's interesting that the MSP failure has managed to fudge the entire
DMA Controller. I have absolutely no idea how that can even happen?


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
