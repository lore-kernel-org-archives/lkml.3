Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3H1Sta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:49:30 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40749 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3H1St2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:49:28 -0400
Date: Wed, 28 Aug 2013 19:49:22 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] input: ti_am335x_tsc: Enable shared IRQ for TSC
Message-ID: <20130828184921.GC3777@gmail.com>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-2-git-send-email-zubair.lutfullah@gmail.com>
 <20130828104211.GB14111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828104211.GB14111@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:42:11PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-25 23:45:23 [+0100]:
> 
> >diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> >index e1c5300..4124e580 100644
> >--- a/drivers/input/touchscreen/ti_am335x_tsc.c
> >+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> >@@ -315,11 +321,17 @@ static irqreturn_t titsc_irq(int irq, void *dev)
...
> >+	/* If any IRQ flags left, return none. So ADC can handle its IRQs */
> >+	status = titsc_readl(ts_dev, REG_IRQSTATUS);
> >+	if (status == false)
> >+		return IRQ_HANDLED;
> >+	else
> >+		return IRQ_NONE;
> 
> If I understand this correctly you return IRQ_NONE the TSC interrupt has
> been handled and no ADC interrupt is outstanding.

Its actually the opposite. TSC handler checks if there are any ADC IRQ flags
outstanding.

If there is no outstanding, then IRQ_HANDLED is returned.
If there is ADC IRQ outstanding, then IRQ_NONE is returned.

ZubairLK
