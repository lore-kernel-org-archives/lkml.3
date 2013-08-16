Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3HPO7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:59:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:39922 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3HPO7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:59:51 -0400
Date: Fri, 16 Aug 2013 16:59:49 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816145949.GE1263@linutronix.de>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-13 21:05:03 [+0100]:

>diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
>index 3ceac3e..0d7e313 100644
>--- a/drivers/iio/adc/ti_am335x_adc.c
>+++ b/drivers/iio/adc/ti_am335x_adc.c
…

>+static int tiadc_buffer_postdisable(struct iio_dev *indio_dev)
>+{
>+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>+	int config;
>+
>+	tiadc_step_config(indio_dev);
>+	if (adc_dev->mfd_tscadc->tsc_cell == -1) {
>+		config = tiadc_readl(adc_dev, REG_CTRL);
>+		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
>+	}

This kind of check is bad. The tsc cell may have been created but the
driver not enabled or loaded. Further you should document why you need
to enable / disable the ADC in this places and only if the TSC part is
not active.

Sebastian
