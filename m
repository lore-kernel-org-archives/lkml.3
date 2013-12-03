Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3LCKAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:00:09 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40323 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3LCKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:00:04 -0500
Date: Tue, 3 Dec 2013 09:59:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 3/3] ASoC: ux500: Dynamically fill DAI
 driver data on probe
Message-ID: <20131203095958.GH11828@lee--X1>
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
 <1386007222-10081-3-git-send-email-lee.jones@linaro.org>
 <529CCD2F.3060206@metafoo.de>
 <20131203084026.GC11828@lee--X1>
 <529D9D14.9040109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529D9D14.9040109@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>[...]
> >>>+void ux500_msp_populate_dai_drv(struct snd_soc_dai_driver *ux500_msp_dai_drv)
> >>>+{
> >>>+	ux500_msp_dai_drv->probe                 = ux500_msp_dai_probe;
> >>>+	ux500_msp_dai_drv->suspend               = NULL;
> >>>+	ux500_msp_dai_drv->resume                = NULL;
> >>>+	ux500_msp_dai_drv->playback.channels_min = UX500_MSP_MIN_CHANNELS;
> >>>+	ux500_msp_dai_drv->playback.channels_max = UX500_MSP_MAX_CHANNELS;
> >>>+	ux500_msp_dai_drv->playback.rates        = UX500_I2S_RATES;
> >>>+	ux500_msp_dai_drv->playback.formats      = UX500_I2S_FORMATS;
> >>>+	ux500_msp_dai_drv->capture.channels_min  = UX500_MSP_MIN_CHANNELS;
> >>>+	ux500_msp_dai_drv->capture.channels_max  = UX500_MSP_MAX_CHANNELS;
> >>>+	ux500_msp_dai_drv->capture.rates         = UX500_I2S_RATES;
> >>>+	ux500_msp_dai_drv->capture.formats       = UX500_I2S_FORMATS;
> >>>+	ux500_msp_dai_drv->ops                   = ux500_msp_dai_ops;
> >>>  };
> >>
> >>You can just use the same static driver for all devices. No need to
> >>dynamically allocate it.
> >
> >How do you mean? Just create a 'static struct' instead?
> 
> Yes.
> 
> static struct snd_soc_dai_driver ux500_msp_dai_driver = {
> 	...
> };

Yes, that's no issue. I was more focused on the reduction of code
than anything else, but that is a better idea.

I'll resubmit.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
