Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIDPda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:33:30 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:26405
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751228AbaIDPd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:33:28 -0400
From: "Yang, Robert" <RYang@hach.com>
To: Lee Jones <lee.jones@linaro.org>, ryang <hachyang@gmail.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] PWM Backlight: Fix a bug which could cause the PWM
 backlight driver use the wrong PWM chip and fail the driver probing if
 multiple PWM chips exist. This defect could also cause the unintended PWM
 chip  used and unaccessable by other dri...
Thread-Topic: [PATCH 1/1] PWM Backlight: Fix a bug which could cause the PWM
 backlight driver use the wrong PWM chip and fail the driver probing if
 multiple PWM chips exist. This defect could also cause the unintended PWM
 chip  used and unaccessable by other dri...
Thread-Index: AQHPyBuy6oKqAeBIhUyYhK4SQrQRPJvw6nQAgAAvCfA=
Date: Thu, 4 Sep 2014 15:33:14 +0000
Message-ID: <D68D4F79CA301E4CB7967E4AF003840725306D49@DHRNASVXM01.danaher.org>
References: <1409774437-39530-1-git-send-email-ryang@hach.com>
 <20140904083852.GE8257@lee--X1> <20140904083958.GF8257@lee--X1>
In-Reply-To: <20140904083958.GF8257@lee--X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-exclaimer-md-config: b0de59f4-6c3d-4798-9ac9-c3e87dd7c495
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.90.113.11;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(377454003)(199003)(13464003)(51704005)(53416004)(77096002)(2656002)(87936001)(67736004)(106116001)(95666004)(47776003)(106466001)(64706001)(80022001)(20776003)(107046002)(83072002)(23676002)(81342001)(85852003)(81542001)(92726001)(86362001)(85306004)(90102001)(118246001)(92566001)(21056001)(4396001)(74502001)(74662001)(6806004)(31966008)(44976005)(19580405001)(19580395003)(83322001)(25786005)(33656002)(76176999)(99396002)(54356999)(50466002)(76482001)(55846006)(50986999)(46102001)(79102001)(77982001)(61373001)(219693003)(80792004);DIR:OUT;SFP:;SCL:1;SRVR:CO2PR0701MB1000;H:dhrnadzgw02.danahermail.com;FPR:;MLV:sfv;PTR:dhrnadzgw02.danahermail.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=pass (sender IP is 64.90.113.11)
 smtp.mailfrom=RYang@hach.com; 
X-OriginatorOrg: hach.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84FXZxI010880

Hi Lee,
It is great to get your reply. No, this is  a second one, actually it is a resend. This time I just followed Thierry's instruction using the git patch and send-mail commands.

Robert


-----Original Message-----
From: Lee Jones [mailto:lee.jones@linaro.org]
Sent: Thursday, September 04, 2014 2:40 AM
To: ryang
Cc: thierry.reding@gmail.com; jg1.han@samsung.com; linux-pwm@vger.kernel.org; Yang, Robert; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PWM Backlight: Fix a bug which could cause the PWM backlight driver use the wrong PWM chip and fail the driver probing if multiple PWM chips exist. This defect could also cause the unintended PWM chip used and unaccessable by other dri...

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
> > diff --git a/drivers/video/backlight/pwm_bl.c
> > b/drivers/video/backlight/pwm_bl.c
> > index b85983e..e0014a5 100644
> > --- a/drivers/video/backlight/pwm_bl.c
> > +++ b/drivers/video/backlight/pwm_bl.c
> > @@ -273,6 +273,9 @@ static int pwm_backlight_probe(struct
> > platform_device *pdev)
> >
> >     pb->pwm = devm_pwm_get(&pdev->dev, NULL);
> >     if (IS_ERR(pb->pwm)) {
> > +           ret = PTR_ERR(pb->pwm);
> > +           if (ret == -EPROBE_DEFER)
> > +                   goto err_alloc;
> >             dev_err(&pdev->dev, "unable to request PWM, trying legacy
> > API\n");
> >
> >             pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
>

--
Lee Jones
Linaro STMicroelectronics Landing Team Lead Linaro.org â”‚ Open source software for ARM SoCs Follow Linaro: Facebook | Twitter | Blog
Please be advised that this email may contain confidential information. If you are not the intended recipient, please notify us by email by replying to the sender and delete this message. The sender disclaims that the content of this email constitutes an offer to enter into, or the acceptance of, any agreement; provided that the foregoing does not invalidate the binding effect of any digital or other electronic reproduction of a manual signature that is included in any attachment.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
