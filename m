Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3HTQ1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:27:07 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:51930 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3HTQ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:27:05 -0400
Date: Tue, 20 Aug 2013 17:26:58 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130820162657.GA6776@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <20130819171238.GA31610@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130819171238.GA31610@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 07:12:38PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-13 21:05:03 [+0100]:
> 
> >diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> >index 3ceac3e..0d7e313 100644
> >--- a/drivers/iio/adc/ti_am335x_adc.c
> >+++ b/drivers/iio/adc/ti_am335x_adc.c
> …
> >+static irqreturn_t tiadc_irq(int irq, void *private)
> >+{
> …
> >+		wake_up_interruptible(&adc_dev->wq_data_avail);
> …
> >+}
> …
> >+static irqreturn_t tiadc_trigger_h(int irq, void *p)
> >+{
> …
> >+	schedule_work(&adc_dev->poll_work);
> …
> >+}
> …
> >+static void tiadc_adc_work(struct work_struct *work_s)
> >+{
> …
> >+		wait_event_interruptible(adc_dev->wq_data_avail,
> >+					(adc_dev->data_avail == 1));
> …
> >+}
> 
> This is not very nice. The problem is that you might sleep in a
> workqueue and so the other jobs will wait until you are done. I'm think
This will change to a different style.

> I'm looking into DMA support for this so once your code is working it
> should be possible to switch to DMA instead reading byte wise from the
> fifo.
Great.

> How did you test the whole thing? Do you have a test program which
> selects a few sources and reads them in continuous mode?
> 
generic_buffer.c runs for this for sysfs trigger.. 
However. If you follow the other thread. 
This is obsolete and trigger style is changing to a driver trigger.

I'll update when I'm done.

Thanks
ZubairLK
