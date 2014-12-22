Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaLVIjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:39:43 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39822 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaLVIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:39:41 -0500
MIME-Version: 1.0
In-Reply-To: <1417914095-26553-1-git-send-email-jcmvbkbc@gmail.com>
References: <1417914095-26553-1-git-send-email-jcmvbkbc@gmail.com>
Date: Mon, 22 Dec 2014 11:39:40 +0300
Message-ID: <CAMo8BfJCPU_ZM0w2Ry9kjU3O+HcWEmp_wgZ44oC7gBLW8DV5jw@mail.gmail.com>
Subject: Re: [PATCH v3] ASoC: add xtensa xtfpga I2S interface and platform
From: Max Filippov <jcmvbkbc@gmail.com>
To: alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2014 at 4:01 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> XTFPGA boards provides an audio subsystem that consists of TI CDCE706
> clock synthesizer, I2S transmitter and TLV320AIC23 audio codec.
>
> I2S transmitter has MMIO-based interface that resembles that of the
> OpenCores I2S transmitter. I2S transmitter is always a master on I2S
> bus. There's no specialized audio DMA, sample data are transferred to
> I2S transmitter FIFO by CPU through memory-mapped queue interface.

Ping?

> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
> Changes v2->v3:
> - drop .owner = THIS_MODULE from the struct platform_driver initialization;
> - rebase to 3.18-rc7.
>
> Changes v1->v2:
> - fix module name in the sound/soc/xtensa/Makefile;
> - split PCM data transfer code and I2S interface setup code;
> - move clock enabling/disabling to runtime PM code;
> - document I2S interface RATIO field;
> - rewrite I2S interface LEVEL field calculation to avoid overflows;
> - drop select statements from Kconfig;
> - document RCU usage for tx_substream;
> - clean up code running in RCU read-side critical section;
> - use threaded IRQ handler instead of IRQ + tasklet;
> - remove empty PCM callback handlers;
> - add const to static structures where applicable;
> - use platform_set_drvdata instead of dev_set_drvdata;
> - drop redundant error reporting code;
> - use platform_get_irq instead of platform_get_resource;
> - clean up xtfpga_i2s_remove;
> - add comments.
>
>  .../devicetree/bindings/sound/cdns,xtfpga-i2s.txt  |  18 +
>  MAINTAINERS                                        |   1 +
>  sound/soc/Kconfig                                  |   1 +
>  sound/soc/Makefile                                 |   1 +
>  sound/soc/xtensa/Kconfig                           |   7 +
>  sound/soc/xtensa/Makefile                          |   3 +
>  sound/soc/xtensa/xtfpga-i2s.c                      | 675 +++++++++++++++++++++
>  7 files changed, 706 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/cdns,xtfpga-i2s.txt
>  create mode 100644 sound/soc/xtensa/Kconfig
>  create mode 100644 sound/soc/xtensa/Makefile
>  create mode 100644 sound/soc/xtensa/xtfpga-i2s.c

-- 
Thanks.
-- Max
