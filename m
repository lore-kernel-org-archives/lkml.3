Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaIJSHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:07:51 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44557 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIJSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:07:49 -0400
Date: Wed, 10 Sep 2014 11:07:36 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        perex@perex.cz, tiwai@suse.de, timur@tabi.org, Li.Xiubo@freescale.com,
        grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/5] ASoC: fsl: add imx-tlv320aic3x machine driver
Message-ID: <20140910180735.GB4628@Asurada>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
   
On Wed, Sep 10, 2014 at 04:46:46PM +0300, Dmitry Lavnikevich wrote:
> This is driver for i.MX6 boards with tlv320aic3x audio codecs.
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> ---
>  .../bindings/sound/fsl,imx-audio-tlv320aic3x.txt   |  27 ++++
>  sound/soc/fsl/Kconfig                              |  13 ++
>  sound/soc/fsl/Makefile                             |   2 +
>  sound/soc/fsl/imx-tlv320aic3x.c                    | 177 +++++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/fsl,imx-audio-tlv320aic3x.txt
>  create mode 100644 sound/soc/fsl/imx-tlv320aic3x.c

This whole single patch looks pretty clean. So I suggest it may be merged
into fsl-asoc-card.c driver whose DT binding is almost identical to yours
so that we don't need to add a machine driver with duplicated code. And
you can feel free to enable fsl-asoc-card in the defconfig as well -- I
was about to do it and to replace imx-wm8962 and imx-sgtl5000 with it.

The only extra trivia you need to tackle is to add a clock binding into
your dts for CODEC side.

Thanks
Nicolin
