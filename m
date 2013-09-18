Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3IRGyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:54:19 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37093 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3IRGyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:54:18 -0400
Date: Wed, 18 Sep 2013 11:54:07 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130918065406.GA13451@gmail.com>
References: <1379393047-11772-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379393047-11772-3-git-send-email-zubair.lutfullah@gmail.com>
 <20130918042726.GB13196@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918042726.GB13196@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 09:27:27PM -0700, Dmitry Torokhov wrote:
> Hi Zubair,
> 
> On Tue, Sep 17, 2013 at 09:44:07AM +0500, Zubair Lutfullah wrote:
> > +
> > +	ret = devm_request_threaded_irq(indio_dev->dev.parent,
> > +				irq,
> > +				pollfunc_th, pollfunc_bh,
> > +				flags, indio_dev->name,
> > +				indio_dev);
> > +	if (ret)
> > +		goto error_kfifo_free;
> > +
> > +	indio_dev->setup_ops = setup_ops;
> > +	indio_dev->modes |= INDIO_BUFFER_HARDWARE;
> > +
> > +	ret = iio_buffer_register(indio_dev,
> > +				  indio_dev->channels,
> > +				  indio_dev->num_channels);
> > +	if (ret)
> > +		goto error_free_irq;
> > +
> > +	return 0;
> > +
> > +error_free_irq:
> > +	devm_free_irq(indio_dev->dev.parent, irq, indio_dev);
> 
> What is the point of using devm_* here if you are doing explicit
> management of the resource anyway (you explicitly release it in all code
> paths)?
> 
> Thanks.
> 
> -- 
> Dmitry

I admit I am unaware at the moment about how it works.

I use devm and simply ignore the error path?

The devm function header description said something about using
devm_free when freeing. And this is the way I am used to seeing 
error handling.

Zubair
