Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaIDIkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:40:06 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43308 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaIDIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:40:04 -0400
Date: Thu, 4 Sep 2014 09:39:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: ryang <hachyang@gmail.com>
Cc: thierry.reding@gmail.com, jg1.han@samsung.com, linux-pwm@vger.kernel.org,
        ryang <ryang@hach.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PWM Backlight: Fix a bug which could cause the PWM
 backlight driver use the wrong PWM chip and fail the driver probing if
 multiple PWM chips exist. This defect could also cause the unintended PWM
 chip  used and unaccessable by other drivers. The patch will check the error
 state first and allow a deferral PWM backlight probing if the intended PWM
 driver is not loaded at the probing moment.
Message-ID: <20140904083958.GF8257@lee--X1>
References: <1409774437-39530-1-git-send-email-ryang@hach.com>
 <20140904083852.GE8257@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140904083852.GE8257@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm guessing this is your first patch.
> 
> Please read: Documentation/SubmittingPatches
> 
> A few notes for you search for and read about in the above document.
> 
>  - Subject line formatting (short, succinct) 
>  - Commit logs (present, descriptive [what changed and why], succinct)
>  - Authorship (full/real names only)

You also need to CC linux-kernel@vger.kernel.org on all patches.

> > Signed-off-by: ryang <ryang@hach.com>
> > ---
> >  drivers/video/backlight/pwm_bl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> > index b85983e..e0014a5 100644
> > --- a/drivers/video/backlight/pwm_bl.c
> > +++ b/drivers/video/backlight/pwm_bl.c
> > @@ -273,6 +273,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
> >  
> >  	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
> >  	if (IS_ERR(pb->pwm)) {
> > +		ret = PTR_ERR(pb->pwm);
> > +		if (ret == -EPROBE_DEFER)
> > +			goto err_alloc;
> >  		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
> >  
> >  		pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
