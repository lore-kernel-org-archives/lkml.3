Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbaBAOto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:49:44 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55827 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaBAOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:49:43 -0500
Date: Sat, 1 Feb 2014 15:49:39 +0100
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: viperboard: Call platform_set_drvdata before
 devm_iio_device_register
Message-ID: <20140201144939.GA14121@sauron.localdomain>
References: <1391265593-13986-1-git-send-email-morbidrsa@gmail.com>
 <52ED08AD.9060403@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52ED08AD.9060403@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 03:46:05PM +0100, Lars-Peter Clausen wrote:
> On 02/01/2014 03:39 PM, Johannes Thumshirn wrote:
> > Call platform_set_drvdata before devm_iio_device_register to avoid possible
> > race condition when accessing driver data.
>
> I don't think the driver data is accessed from within any of the IIO device
> callbacks. In fact I don't think it is accessed at all with the latest
> conversion to devm_iio_device_register(). So I think the call to
> platform_set_drvdata can just be removed.
>
> >
> > Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> > ---
> >  drivers/iio/adc/viperboard_adc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
> > index d0add8f..7d9bd05 100644
> > --- a/drivers/iio/adc/viperboard_adc.c
> > +++ b/drivers/iio/adc/viperboard_adc.c
> > @@ -133,14 +133,14 @@ static int vprbrd_adc_probe(struct platform_device *pdev)
> >  	indio_dev->channels = vprbrd_adc_iio_channels;
> >  	indio_dev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
> >
> > +	platform_set_drvdata(pdev, indio_dev);
> > +
> >  	ret = devm_iio_device_register(&pdev->dev, indio_dev);
> >  	if (ret) {
> >  		dev_err(&pdev->dev, "could not register iio (adc)");
> >  		return ret;
> >  	}
> >
> > -	platform_set_drvdata(pdev, indio_dev);
> > -
> >  	return 0;
> >  }
> >
> >
>

Looks like you're right. So we can drop this patch and I'll make a remove version.
