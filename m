Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaKMO4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:56:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39394 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbaKMO4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:56:37 -0500
Message-ID: <5464C699.3080301@ti.com>
Date: Thu, 13 Nov 2014 20:26:25 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <afenkart@gmail.com>, <nsekhar@ti.com>
Subject: Re: [RFC PATCH 0/3] DRA72: MMC HS200 support
References: <1415890458-20436-1-git-send-email-kishon@ti.com>
In-Reply-To: <1415890458-20436-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for sending this multiple times. There was some problem with my mail
configuration which I have fixed now.

Thanks
Kishon

On Thursday 13 November 2014 08:24 PM, Kishon Vijay Abraham I wrote:
> Added HS200 to improve EMMC throughput for dra72.
> 
> With HS200
> ==============
> Read throughput
> ./dd if=/dev/mmcblk0 of=/dev/null bs=1M count=100 oflag=sync
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 1.46028 s, 71.8 MB/s
> 
> Write throughput
> root@dra7xx-evm:/# ./dd if=/dev/zero of=/dev/mmcblk0 bs=1M count=100 oflag=sync
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 9.34884 s, 11.2 MB/s
> 
> 
> WithOUT HS200
> ==============
> Read throughput
> ./dd if=/dev/mmcblk0 of=/dev/null bs=1M count=100 oflag=sync
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 2.6423 s, 39.7 MB/s
> 
> Write throughput
> ./dd if=/dev/zero of=/dev/mmcblk0 bs=1M count=100 oflag=sync
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 9.3556 s, 11.2 MB/s
> 
> Balaji T K (1):
>   mmc: omap_hsmmc: add tuning support
> 
> Kishon Vijay Abraham I (1):
>   ARM: dts: dra72-evm: Set the max-frequency to 192MHz
> 
> Viswanath Puttagunta (1):
>   mmc: omap_hsmmc: set host capabilities by reading MMCHS_CAPA2
>     register
> 
>  arch/arm/boot/dts/dra72-evm.dts |    1 +
>  drivers/mmc/host/omap_hsmmc.c   |  342 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 341 insertions(+), 2 deletions(-)
> 
