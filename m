Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3HPWOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:14:53 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46879 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3HPWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:14:51 -0400
Date: Fri, 16 Aug 2013 22:10:02 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816210955.GA2528@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <20130816145949.GE1263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130816145949.GE1263@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 04:59:49PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-13 21:05:03 [+0100]:
> 
> >diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> >index 3ceac3e..0d7e313 100644
> >--- a/drivers/iio/adc/ti_am335x_adc.c
> >+++ b/drivers/iio/adc/ti_am335x_adc.c
> …
> 
> >+static int tiadc_buffer_postdisable(struct iio_dev *indio_dev)
> >+{
> >+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> >+	int config;
> >+
> >+	tiadc_step_config(indio_dev);
> >+	if (adc_dev->mfd_tscadc->tsc_cell == -1) {
> >+		config = tiadc_readl(adc_dev, REG_CTRL);
> >+		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
> >+	}
> 
> This kind of check is bad. The tsc cell may have been created but the
> driver not enabled or loaded. Further you should document why you need
> to enable / disable the ADC in this places and only if the TSC part is
> not active.
> 
> Sebastian

Noted. I'll look into it.

Thanks for pointing it out.

Zubair
