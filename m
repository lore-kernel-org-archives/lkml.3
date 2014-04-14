Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaDNKKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:10:18 -0400
Received: from smtp2.digiweb.ie ([83.147.160.14]:45727 "EHLO smtp.digiweb.ie"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754643AbaDNKKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:10:16 -0400
X-Greylist: delayed 1804 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 06:10:15 EDT
Message-ID: <1397468403.2320.10.camel@dan-Latitude-E5440>
Subject: Re: [PATCH] staging: iio: fix coding style
From: "Dan O'Donovan" <dan@emutex.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Joel Porquet <joel@porquet.org>, gregkh@linuxfoundation.org,
        jg1.han@samsung.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Apr 2014 10:40:03 +0100
In-Reply-To: <534977A7.3090100@kernel.org>
References: <1397066985-2504-1-git-send-email-joel@porquet.org>
	 <534977A7.3090100@kernel.org>
Organization: Emutex Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-12 at 18:28 +0100, Jonathan Cameron wrote:
> On 09/04/14 19:09, Joel Porquet wrote:
> > As suggested by checkpatch.pl, use dev_info() instead of
> > printk(KERN_INFO ...) to print message.
> >
> > Signed-off-by: Joel Porquet <joel@porquet.org>
> > ---
> > Only tested by compilation.
> >   drivers/staging/iio/trigger/iio-trig-periodic-rtc.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
> > index 48a6afa..38ecb4b 100644
> > --- a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
> > +++ b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
> > @@ -33,7 +33,8 @@ static int iio_trig_periodic_rtc_set_state(struct iio_trigger *trig, bool state)
> >   	struct iio_prtc_trigger_info *trig_info = iio_trigger_get_drvdata(trig);
> >   	if (trig_info->frequency == 0)
> >   		return -EINVAL;
> > -	printk(KERN_INFO "trigger frequency is %d\n", trig_info->frequency);
> > +	dev_info(&trig_info->rtc->dev, "trigger frequency is %d\n",
> > +			trig_info->frequency);
> The principle is good, but why make the error message us the underlying rtc device?
> Going to lead to a rather unhelpful error message.
> 
> Perhaps the iio_trigger structures device element would make more sense?
> Might not be terribly informative, but will at least come from the right
> subsystem.
> 
> Also, I think we will be dropping this driver entirely at some point.
> It was a dodgy hack that perhaps made sense at the time, but now a high
> resolution timer is going to give better results.

I've been using this patch from Denis Ciocca which implements a hr-timer
trigger, and it has worked well for me:
http://comments.gmane.org/gmane.linux.kernel.iio/9698
It would be great to see this added to the kernel.

> >   	return rtc_irq_set_state(trig_info->rtc, &trig_info->task, state);
> >   }
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

