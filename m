Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaD2GaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:30:00 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51263 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaD2G36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:29:58 -0400
Date: Tue, 29 Apr 2014 14:29:50 +0800
From: Jimmy Li <coder.liss@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Jonathan Cameron'" <jic23@kernel.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Monam Agarwal'" <monamagarwal123@gmail.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:iio:ad2s1210 fix a leak when device removed
Message-ID: <20140429062950.GA24666@gmail.com>
References: <20140429055544.GA23599@gmail.com>
 <001401cf6371$3e98cf90$bbca6eb0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001401cf6371$3e98cf90$bbca6eb0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 03:07:04PM +0900, Jingoo Han wrote:
> On Tuesday, April 29, 2014 2:56 PM, Jimmy Li wrote:
> > 
> > Signed-off-by: Jimmy Li <coder.liss@gmail.com>
> > ---
> >  drivers/staging/iio/resolver/ad2s1210.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
> > index 7fbaba4..3d6e123 100644
> > --- a/drivers/staging/iio/resolver/ad2s1210.c
> > +++ b/drivers/staging/iio/resolver/ad2s1210.c
> > @@ -716,6 +716,7 @@ static int ad2s1210_remove(struct spi_device *spi)
> > 
> >  	iio_device_unregister(indio_dev);
> >  	ad2s1210_free_gpios(iio_priv(indio_dev));
> > +	devm_iio_device_free(&spi->dev, indio_dev);
> 
> NAK.
> 
> In ad2s1210_probe(),devm_iio_device_alloc() was already used.
> So, when ad2s1210_remove() is called, iio_device_free() will
> be called automatically. So, the leak never happens.
> 
> If you want to know about devm_* functions, please refer 
> to the following.
> 
>   Documentation/driver-model/devres.txt

Thank you for your reply,

I understand it now, just ignore this patch.

> 
> Best regards,
> Jingoo Han
> > 
> >  	return 0;
> >  }
> > --
> > 1.7.9.5
> 
