Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3IRE1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 00:27:34 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46099 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3IRE1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 00:27:32 -0400
Date: Tue, 17 Sep 2013 21:27:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130918042726.GB13196@core.coreip.homeip.net>
References: <1379393047-11772-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379393047-11772-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379393047-11772-3-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zubair,

On Tue, Sep 17, 2013 at 09:44:07AM +0500, Zubair Lutfullah wrote:
> +
> +	ret = devm_request_threaded_irq(indio_dev->dev.parent,
> +				irq,
> +				pollfunc_th, pollfunc_bh,
> +				flags, indio_dev->name,
> +				indio_dev);
> +	if (ret)
> +		goto error_kfifo_free;
> +
> +	indio_dev->setup_ops = setup_ops;
> +	indio_dev->modes |= INDIO_BUFFER_HARDWARE;
> +
> +	ret = iio_buffer_register(indio_dev,
> +				  indio_dev->channels,
> +				  indio_dev->num_channels);
> +	if (ret)
> +		goto error_free_irq;
> +
> +	return 0;
> +
> +error_free_irq:
> +	devm_free_irq(indio_dev->dev.parent, irq, indio_dev);

What is the point of using devm_* here if you are doing explicit
management of the resource anyway (you explicitly release it in all code
paths)?

Thanks.

-- 
Dmitry
