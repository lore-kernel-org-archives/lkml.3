Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaGKKDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:03:08 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53676 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbaGKKDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:03:04 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: jianqun <xjq@rock-chips.com>
Cc: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org, zhangqing@rock-chips.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, hj@rock-chips.com,
        kever.yang@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        kfx@rock-chips.com
Subject: Re: [PATCH 0/2] add rockchip i2s driver
Date: Fri, 11 Jul 2014 12:03:50 +0200
Message-ID: <11713484.S15eBXkq6o@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1405072489-20802-1-git-send-email-xjq@rock-chips.com>
References: <1405072489-20802-1-git-send-email-xjq@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,

Am Freitag, 11. Juli 2014, 17:54:47 schrieb jianqun:
> From: Jianqun Xu <xjq@rock-chips.com>
> 
> This patch is to add driver for I2S controller in RK3xxx SoCs.
> 
> The only one change in this patch against which has been reviewed before is
> to fix randconfig build error with next-20140710 by add "#include
> <linux/module.h>".

as you know, the i2s patches were already included in the sound tree ... so 
please create a follow-up patch fixing the randconfig issue, without 
resubmitting the whole series again.


Heiko


> 
> Jianqun Xu (2):
>   ASoC: dt-bindings: add rockchip i2s bindings
> 
> changes since v2:
>  - change the description of dma-names, adviced by Mark
>  - change the description of interrupts, adviced by Mark
>  - list clock-names to be easy to read, adviced by Mark
>  - modify compatible for rk3288 example, adviced by Mark and Heiko
> 
>  changes since v1:
>  - modify the description of clock-names property, adviced by Mark Rutland.
>  - modify the example to fit for rk3288.
> 
> 
>   ASoC: add driver for Rockchip RK3xxx I2S controller
> 
> changes since v3:
>  - fix randconfig build error with next-20140710 by add "#include
> <linux/module.h>" tested with config given by robot test.
> 
> changes since v2:
>  - replace 4 with DMA_SLAVE_BUSWIDTH_4_BYTES
>  - modify supported rate to SNDRV_PCM_RATE_8000_192000
>  - rename head file to "rockchi_i2s.h"
> 
> changes since v1:
>  - proper indentation for function arguments, adviced by Varka Bhadram
>  - replace sizeof(struct rk_i2s_dev) with sizeof(*i2s), adviced by Mark
> Rutland - not to include head files which are unused actually in driver,
> adviced by Mark Brown - modify i2s_tx_status/i2s_rx_status to more
> meaningful with tx_start/rx_start, adviced by Mark Brown - use
> regmap_update_bits to reduce the amount of time spent locked, adviced by
> Mark Brown - add warning for possible error while waiting for the hardware
> to be ready, adviced by Mark Brown - error checking for clk_set_rate,
> adviced by Mark Brown
>  - error checking for i2s_runtime_resume, adviced by Mark Brown
>  - remove set_clkdiv operation, clock setting will do it, adviced by Mark
> Brown - no need SND_SOC for SND_SOC_ROCKCHIP, also allow the driver to be
> select when COMPILE_TEST is selected, adviced by Lars-Peter Clausen
>  - not to include head files which are unused actually in driver, adviced by
> Lars-Peter Clausen - I2S core just use one snd_soc_dai_driver struct,
> adviced by Lars-Peter Clausen - delete rockchip_pcm.c and related codes,
> use generic dmaengine API, adviced by Lars-Peter and Mark Brown - a driver
> should never attempt to change its own device name, just use the name that
> the kernel set, adviced by Lars-Peter and Mark Brown
> 
> 
>  .../devicetree/bindings/sound/rockchip-i2s.txt     |   37 ++
>  sound/soc/Kconfig                                  |    1 +
>  sound/soc/Makefile                                 |    1 +
>  sound/soc/rockchip/Kconfig                         |   12 +
>  sound/soc/rockchip/Makefile                        |    4 +
>  sound/soc/rockchip/rockchip_i2s.c                  |  531
> ++++++++++++++++++++ sound/soc/rockchip/rockchip_i2s.h                  | 
> 223 ++++++++ 7 files changed, 809 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/rockchip-i2s.txt
> create mode 100644 sound/soc/rockchip/Kconfig
>  create mode 100644 sound/soc/rockchip/Makefile
>  create mode 100644 sound/soc/rockchip/rockchip_i2s.c
>  create mode 100644 sound/soc/rockchip/rockchip_i2s.h

