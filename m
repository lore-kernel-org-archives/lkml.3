Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaIYPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:00:59 -0400
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:10193
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753011AbaIYPA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:00:58 -0400
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 11:00:57 EDT
From: "Yang, Robert" <RYang@hach.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        "hachyang@gmail.com" <hachyang@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikolaus Voss <n.voss@weinmann-emt.de>
Subject: RE: [PATCH 1/1] PWM-atmel: Fixed a bug which set the pwm clock
 prescaler incorrectly. In the defect code the prescaler was always one more
 than expected value, which resulted in the pwm output with wrong frequency
 and duty cycle.
Thread-Topic: [PATCH 1/1] PWM-atmel: Fixed a bug which set the pwm clock
 prescaler incorrectly. In the defect code the prescaler was always one more
 than expected value, which resulted in the pwm output with wrong frequency
 and duty cycle.
Thread-Index: AQHPzT9Rr2MrO/uZ40aMXzDTTSlrvJwR1J2AgAAuxwA=
Date: Thu, 25 Sep 2014 14:44:48 +0000
Message-ID: <D68D4F79CA301E4CB7967E4AF0038407253158D1@DHRNASVXM01.danaher.org>
References: <1410384919-41303-1-git-send-email-ryang@hach.com>
 <20140925075508.GB11843@ulmo>
In-Reply-To: <20140925075508.GB11843@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-exclaimer-md-config: b0de59f4-6c3d-4798-9ac9-c3e87dd7c495
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.90.113.10;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(51704005)(189002)(13464003)(377454003)(20776003)(92726001)(47776003)(118246001)(107046002)(575784001)(92566001)(86362001)(64706001)(90102001)(99396003)(81542003)(81342003)(77982003)(46406003)(79102003)(46102003)(85852003)(80022003)(74502003)(74662003)(77096002)(83072002)(95666004)(19580405001)(76176999)(23726002)(90626002)(50986999)(97756001)(54356999)(85306004)(25786005)(50466002)(91026002)(31966008)(4396001)(53416004)(55846006)(33656002)(6806004)(19580395003)(76482002)(67736004)(15975445006)(2501002)(21056001)(87936001)(10300001)(106116001)(106466001)(120916001)(83322001)(2656002)(44976005)(76626009)(46526007)(80792004);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB050;H:dhrnadzgw01.danahermail.com;FPR:;MLV:sfv;PTR:dhrnadzgw01.danahermail.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB050;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=pass (sender IP is 64.90.113.10)
 smtp.mailfrom=RYang@hach.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB850;
X-OriginatorOrg: hach.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

I agree Nikolaus's fix is more efficient and works too.

Robert

-----Original Message-----
From: Thierry Reding [mailto:thierry.reding@gmail.com]
Sent: Thursday, September 25, 2014 1:55 AM
To: hachyang@gmail.com
Cc: linux-pwm@vger.kernel.org; linux-kernel@vger.kernel.org; Yang, Robert; Nikolaus Voss
Subject: Re: [PATCH 1/1] PWM-atmel: Fixed a bug which set the pwm clock prescaler incorrectly. In the defect code the prescaler was always one more than expected value, which resulted in the pwm output with wrong frequency and duty cycle.

On Wed, Sep 10, 2014 at 03:35:19PM -0600, hachyang@gmail.com wrote:
> From: ryang <ryang@hach.com>
>
> Signed-off-by: ryang <ryang@hach.com>
> ---
>  drivers/pwm/pwm-atmel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c index
> 6e700a5..2dca0bf 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -128,7 +128,8 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>                       return -EINVAL;
>               }
>       }
> -
> +     /* Need to reduce the prescaler by 1 */
> +     pres--;
>       /* Calculate the duty cycles */
>       prd = div;
>       div *= duty_ns;
> --
> 1.9.1

I think this was fixed by a different patch by Nikolaus in a more direct way, see: https://lkml.org/lkml/2014/9/24/28

I've pushed that patch to the for-next branch of the PWM tree. Can you verify that the issue you were seeing is gone?

Thierry
Please be advised that this email may contain confidential information. If you are not the intended recipient, please notify us by email by replying to the sender and delete this message. The sender disclaims that the content of this email constitutes an offer to enter into, or the acceptance of, any agreement; provided that the foregoing does not invalidate the binding effect of any digital or other electronic reproduction of a manual signature that is included in any attachment.
