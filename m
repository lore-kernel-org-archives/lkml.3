Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaDNTPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:15:37 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:58640 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754382AbaDNTPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:15:36 -0400
X-Greylist: delayed 12600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 15:15:36 EDT
From: =?ISO-8859-1?Q?Jo=EBl?= Porquet <joel@porquet.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: gregkh@linuxfoundation.org, jg1.han@samsung.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: fix coding style
Date: Mon, 14 Apr 2014 15:59:32 +0200
Message-ID: <9773833.iVsvHLKPbr@joel-zenbook>
User-Agent: KMail/4.12.4 (Linux/3.14.0-4-ARCH; KDE/4.12.4; x86_64; ; )
In-Reply-To: <534977A7.3090100@kernel.org>
References: <1397066985-2504-1-git-send-email-joel@porquet.org> <534977A7.3090100@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Ovh-Tracer-Id: 16846840306135625811
X-Ovh-Remote: 184.153.170.46 (cpe-184-153-170-46.maine.res.rr.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Saturday, April 12, 2014 06:28:07 PM Jonathan Cameron wrote:
> 
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

OK, thanks for the feedback!

Does that still make sense that I resubmit another patch (using iio_trigger-dev instead)?
Or should I just drop this patch altogether since you seem to say that patching this driver is not really worth it anyway?

> >   	return rtc_irq_set_state(trig_info->rtc, &trig_info->task, state);
> >   }
> >
> >
> 
