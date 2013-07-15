Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3GOXBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:01:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51433 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3GOXBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:01:16 -0400
X-Auth-Info: RmVrQ13qtjHK2+PYd506bNWYI8AVbKBymuMZU1oXgRU=
From: Marek Vasut <marex@denx.de>
To: Otavio Salvador <otavio@ossystems.com.br>
Subject: Re: [PATCH 2/5] ARM: mxs-lradc: Simplify mxs_lradc_trigger_init error handle
Date: Tue, 16 Jul 2013 01:00:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Lars-Peter Clausen" <lars@metafoo.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br> <201307151624.57438.marex@denx.de> <CAP9ODKqOEd_002KJ3xFQ0uQfNEoZosrD9UGPQ=rLS0W3N77XwQ@mail.gmail.com>
In-Reply-To: <CAP9ODKqOEd_002KJ3xFQ0uQfNEoZosrD9UGPQ=rLS0W3N77XwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307160100.26746.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Otavio Salvador,

> On Mon, Jul 15, 2013 at 11:24 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > Dear Otavio Salvador,
> > 
> >> As we have a 'ret' variable with the iio_trigger_register return, this
> >> can be used as result.
> >> 
> >> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
> >> ---
> >> 
> >>  drivers/staging/iio/adc/mxs-lradc.c | 6 ++----
> >>  1 file changed, 2 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/drivers/staging/iio/adc/mxs-lradc.c
> >> b/drivers/staging/iio/adc/mxs-lradc.c index d92c97a..6d41846 100644
> >> --- a/drivers/staging/iio/adc/mxs-lradc.c
> >> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> >> @@ -671,14 +671,12 @@ static int mxs_lradc_trigger_init(struct iio_dev
> >> *iio) trig->ops = &mxs_lradc_trigger_ops;
> >> 
> >>       ret = iio_trigger_register(trig);
> >> 
> >> -     if (ret) {
> >> +     if (ret)
> >> 
> >>               iio_trigger_free(trig);
> >> 
> >> -             return ret;
> >> -     }
> >> 
> >>       iio->trig = trig;
> > 
> > You are still setting iio->trig , you dont want to do that in case of
> > failure
> 
> In this case it'd end being NULL I think, wouldn't it?

It won't, see the implementation in:

drivers/iio/industrialio-trigger.c

Best regards,
Marek Vasut
