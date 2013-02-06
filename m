Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3BFMlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:41:11 -0500
Received: from smtp2.goneo.de ([212.90.139.82]:56219 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3BFMlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:41:09 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.897
From: Lars Poeschel <poeschel@lemonage.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH 0/3] omap_hsmmc DT DMA Client support
Date: Wed, 6 Feb 2013 13:41:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1359752479-29427-1-git-send-email-mporter@ti.com>
In-Reply-To: <1359752479-29427-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061341.06964.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt!

At first thanks for you efforts on DMA Engine on AM33XX.

On Friday 01 February 2013 at 22:01:17, Matt Porter wrote:
> This series adds DT DMA Engine Client support to the omap_hsmmc.
> It leverages the generic DMA OF helpers in -next and the
> dma_request_slave_channel_compat() wrapper introduced in the
> AM33XX DMA Engine series to support DMA in omap_hsmmc on platforms
> booting via DT. These platforms include omap2/3/4/5 and am33xx.
> 
> These patches were split out from the v5 version of the AM33XX DMA
> series and split from the EDMA-specific omap_hsmmc changes.
> 
> The series depends on the following patches:
> 
> 	- dmaengine DT support and edma dmaengine driver fix from
> 	  the git://git.infradead.org/users/vkoul/slave-dma.git next
> 	  branch
> 	- dma_request_slave_channel_compat() support
> 	  https://patchwork.kernel.org/patch/2081671/
> 
> The series with all dependencies can be found at
> https://github.com/ohporter/linux/tree/omap-hsmmc-dt-dmaengine-v1

I cloned your github repository and did short testing with it. I get the 
following error when the kernel mounts my sd-card:

Starting udev
[    5.884738] udevd[72]: starting version 182
[    8.879651] edma-dma-engine edma-dma-engine.0: Exceeded max SG segments 33 
> 16
[    8.887377] omap_hsmmc mmc.3: prep_slave_sg() failed
[    8.892588] omap_hsmmc mmc.3: MMC start dma failure
[    8.897725] mmcblk0: unknown error -1 sending read/write command, card 
status 0x900
[    8.905889] end_request: I/O error, dev mmcblk0, sector 17039
[    8.911926] end_request: I/O error, dev mmcblk0, sector 17047
[    8.917934] end_request: I/O error, dev mmcblk0, sector 17055
[    8.923960] end_request: I/O error, dev mmcblk0, sector 17063
[    8.929967] end_request: I/O error, dev mmcblk0, sector 17071
[    8.935988] end_request: I/O error, dev mmcblk0, sector 17079
[    8.942010] end_request: I/O error, dev mmcblk0, sector 17087
[    8.948016] end_request: I/O error, dev mmcblk0, sector 17095
[    8.954037] end_request: I/O error, dev mmcblk0, sector 17103
[    8.960043] end_request: I/O error, dev mmcblk0, sector 17111
[    9.020919] EXT4-fs error (device mmcblk0p2): __ext4_get_inode_loc:3764: 
inode #8: block 239: comm mount: unable to read itable block
[    9.033514] EXT4-fs (mmcblk0p2): no journal found
[    9.043799] kjournald starting.  Commit interval 5 seconds
[    9.049589] EXT3-fs (mmcblk0p2): warning: mounting fs with errors, running 
e2fsck is recommended
[    9.060940] EXT3-fs (mmcblk0p2): using internal journal
[    9.066437] EXT3-fs (mmcblk0p2): recovery complete
[    9.071460] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode

After that the filesystem on the sd-card has an error that I have to fix with 
e2fsck. As rootfs I use a nfsroot.
In my quick tests, same setup, I don't get any error on edma-dmaengine-
am33xx-v5 branch of your repository.
If you need any further information, let me now.

Regards,
Lars
