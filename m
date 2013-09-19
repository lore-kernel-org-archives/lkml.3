Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3ISFQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 01:16:28 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48109 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3ISFQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 01:16:26 -0400
Date: Thu, 19 Sep 2013 10:16:12 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130919051611.GA4363@gmail.com>
References: <1379393047-11772-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379393047-11772-3-git-send-email-zubair.lutfullah@gmail.com>
 <20130918042726.GB13196@core.coreip.homeip.net>
 <20130918065406.GA13451@gmail.com>
 <53771776-0d33-436d-9687-995ed0d6345d@email.android.com>
 <20130918141533.GA16424@core.coreip.homeip.net>
 <b37c9a0e-36ed-49bf-bb68-453c7b07b437@email.android.com>
 <20130918162442.GA14803@core.coreip.homeip.net>
 <c141b8a3-1e5d-406c-bcc4-ef0abec56192@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c141b8a3-1e5d-406c-bcc4-ef0abec56192@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 06:05:12PM +0100, Jonathan Cameron wrote:
> 
> >> >However in this case such conversion us dangerous. With all but IRQ
> >> >resource managed by the traditional methods they will be released
> >first
> >> >with IRQ handler deregistered very last. Therefore if device is not
> >> >properly quiesced IRQ raised during driver unbinding is likely to
> >> >result
> >> >in kernel oops.
> >> >
> >> >IOW devm_request_irq() is very often evil (it is still useful if
> >_all_
> >> >your resources are managed by devm_*).
> >> >
> >> >In case of your driver I'd recommend switching to
> >> >request_irq()/free_irq() instead.
> >> >
> >> >Thanks.
> >> 
> >> Pretty much all resources are devm managed in here
> >> 
> >>
> >https://git.kernel.org/cgit/linux/kernel/git/jic23/iio.git/tree/drivers/iio/adc/ti_am335x_adc.c?h=togreg&id=7a1aeba7ed0d5a1e83fd5a8ee2a2869430d40347
> >
> >
> >So we are guaranteed that that new kfifo that is being allocated just
> >before we requesting IRQ and will be freed way before we free the IRQ
> >will not be used by the IOTQ handler?
> >
> >Thanks.
> Good point. I forgot about that.  The source of interrupts 'should' be disabled before the kfifo is freed but I guess perhaps better to play it safe. Would take a fair bit of review to be sure that is not going to cause grief.
> 
> A few more devm handlers need writing before it is truly useful here.
> 
> Thanks for pointing this out.
> 
> J

If I understand the conclusion correctly, no devm here?

Zubair
