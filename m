Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaDNQK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:10:57 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56650 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaDNQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:10:55 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <9773833.iVsvHLKPbr@joel-zenbook>
References: <1397066985-2504-1-git-send-email-joel@porquet.org> <534977A7.3090100@kernel.org> <9773833.iVsvHLKPbr@joel-zenbook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] staging: iio: fix coding style
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 14 Apr 2014 17:10:46 +0100
To: =?ISO-8859-1?Q?Jo=EBl_Porquet?= <joel@porquet.org>
CC: gregkh@linuxfoundation.org, jg1.han@samsung.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Message-ID: <d930c33f-3421-4c58-b033-57e99113540c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On April 14, 2014 2:59:32 PM GMT+01:00, "Joël Porquet" <joel@porquet.org> wrote:
>
>
>On Saturday, April 12, 2014 06:28:07 PM Jonathan Cameron wrote:
>> 
>> On 09/04/14 19:09, Joel Porquet wrote:
>> > As suggested by checkpatch.pl, use dev_info() instead of
>> > printk(KERN_INFO ...) to print message.
>> >
>> > Signed-off-by: Joel Porquet <joel@porquet.org>
>> > ---
>> > Only tested by compilation.
>> >   drivers/staging/iio/trigger/iio-trig-periodic-rtc.c | 3 ++-
>> >   1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
>b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
>> > index 48a6afa..38ecb4b 100644
>> > --- a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
>> > +++ b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
>> > @@ -33,7 +33,8 @@ static int iio_trig_periodic_rtc_set_state(struct
>iio_trigger *trig, bool state)
>> >   	struct iio_prtc_trigger_info *trig_info =
>iio_trigger_get_drvdata(trig);
>> >   	if (trig_info->frequency == 0)
>> >   		return -EINVAL;
>> > -	printk(KERN_INFO "trigger frequency is %d\n",
>trig_info->frequency);
>> > +	dev_info(&trig_info->rtc->dev, "trigger frequency is %d\n",
>> > +			trig_info->frequency);
>> The principle is good, but why make the error message us the
>underlying rtc device?
>> Going to lead to a rather unhelpful error message.
>> 
>> Perhaps the iio_trigger structures device element would make more
>sense?
>> Might not be terribly informative, but will at least come from the
>right
>> subsystem.
>> 
>> Also, I think we will be dropping this driver entirely at some point.
>> It was a dodgy hack that perhaps made sense at the time, but now a
>high
>> resolution timer is going to give better results.
>
>OK, thanks for the feedback!
>
>Does that still make sense that I resubmit another patch (using
>iio_trigger-dev instead)?
>Or should I just drop this patch altogether since you seem to say that
>patching this driver is not really worth it anyway?
Up to you. Nothing wrong with setting a good example even in code we aim ultimately
 drop the code! I doubt we will do it for a cycle or two yet
>
>> >   	return rtc_irq_set_state(trig_info->rtc, &trig_info->task,
>state);
>> >   }
>> >
>> >
>> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
