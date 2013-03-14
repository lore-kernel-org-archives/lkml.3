Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab3CNMza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:55:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49274 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:55:28 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 1/3] pwm: davinci: Add Kconfig support for ECAP & EHRPWM
 devices
Thread-Topic: [PATCH 1/3] pwm: davinci: Add Kconfig support for ECAP &
 EHRPWM devices
Thread-Index: AQHOIJ9WyjtWH0oEmk2BClfJ1npOrZiks5wAgABq0QA=
Date: Thu, 14 Mar 2013 12:54:08 +0000
Deferred-Delivery: Thu, 14 Mar 2013 12:54:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA96FA6@DBDE01.ent.ti.com>
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
 <1363257158-11615-2-git-send-email-avinashphilip@ti.com>
 <5141B6D8.2050308@ti.com>
In-Reply-To: <5141B6D8.2050308@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2ECta0i030290

On Thu, Mar 14, 2013 at 17:09:04, Nori, Sekhar wrote:
> On 3/14/2013 4:02 PM, Philip Avinash wrote:
> > Add EHRPWM and ECAP support build support for DAVINCI_DA850 platforms.
> > 
> > Also, since DAVINCI platforms doesn't support TI-PWM-Subsystem module,
> > remove the select option for CONFIG_PWM_TIPWMSS.
> > 
> > Also, update CONFIG_PWM_TIPWMSS compiler directive appropriately in
> > pwm-tipwmss.h to fix the below compiler error upon removal of
> > CONFIG_PWM_TIPWMSS for Davinci platforms.
> > 
> > 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_probe':
> > 	drivers/pwm/pwm-tiecap.c:263:4: error: 'PWMSS_ECAPCLK_EN' undeclared
> > 	(first use in this function)
> > 	drivers/pwm/pwm-tiecap.c:263:4: note: each undeclared identifier
> > 	is reported only once for each function it appears in
> > 	drivers/pwm/pwm-tiecap.c:264:17: error: 'PWMSS_ECAPCLK_EN_ACK'
> > 	undeclared (first use in this function)
> > 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_remove':
> > 	drivers/pwm/pwm-tiecap.c:291:49: error: 'PWMSS_ECAPCLK_STOP_REQ'
> > 	undeclared (first use in this function)
> > 	make[2]: *** [drivers/pwm/pwm-tiecap.o] Error 1
> > 	make[1]: *** [drivers/pwm] Error 2
> > 	make: *** [drivers] Error 2
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> 
> >  config  PWM_TIECAP
> >  	tristate "ECAP PWM support"
> > -	depends on SOC_AM33XX
> > -	select PWM_TIPWMSS
> > +	depends on SOC_AM33XX || ARCH_DAVINCI_DA850
> 
> Having such narrow dependencies is wrong. The same device is present on
> DaVinci DA830 too. A depends on should not be required at all since the
> driver should build on all architectures. But I have seen resistance to
> doing that since users don't like to see configuration options totally
> irrelevant for the architecture they are building for. So may be take a
> middle path and do 'depends on ARCH_ARM'?

I will add dependency only on ARCH_ARM and submit another version.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
