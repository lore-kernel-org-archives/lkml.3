Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaEHOZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:25:38 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.153]:56637 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaEHOZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:25:37 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-5.tower-178.messagelabs.com!1399559131!27605072!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: RE: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Topic: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Thread-Index: AQHPai811ktIYG/SiUKpD6iCr9lWpZs2vMAg
Date: Thu, 8 May 2014 14:25:30 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A7A7BBF0@SW-EX-MBX02.diasemi.com>
References: <cover.1399465372.git.stwiss.opensource@diasemi.com>
	<3cca26c6dedcfd95df75d44e10a27447350c6e35.1399465372.git.stwiss.opensource@diasemi.com>
 <20140507130106.409f65f673317710104d7681@linux-foundation.org>
In-Reply-To: <20140507130106.409f65f673317710104d7681@linux-foundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07 May 2014 21:01, Andrew Morton [mailto:akpm@linux-foundation.org] wrote:
>
>So how does this look?
>
>--- a/drivers/rtc/rtc-da9063.c~rtc-da9063-rtc-driver-fix
>+++ a/drivers/rtc/rtc-da9063.c
>@@ -82,6 +82,7 @@ static void da9063_tm_to_data(struct rtc
> static int da9063_rtc_stop_alarm(struct device *dev)
> {
> 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
>+
> 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
> 				  DA9063_ALARM_ON, 0);
> }
>@@ -89,6 +90,7 @@ static int da9063_rtc_stop_alarm(struct
> static int da9063_rtc_start_alarm(struct device *dev)
> {
> 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
>+
> 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
> 				  DA9063_ALARM_ON, DA9063_ALARM_ON);
> }
>@@ -115,13 +117,12 @@ static int da9063_rtc_read_time(struct d
>
> 	da9063_data_to_tm(data, tm);
>
>-	(void)rtc_tm_to_time(tm, &tm_secs);
>-	(void)rtc_tm_to_time(&rtc->alarm_time, &al_secs);
>+	rtc_tm_to_time(tm, &tm_secs);
>+	rtc_tm_to_time(&rtc->alarm_time, &al_secs);
>
> 	/* handle the rtc synchronisation delay */
> 	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
>-		(void)memcpy((void *)tm, (const void *)&rtc->alarm_time,
>-			     sizeof(struct rtc_time));
>+		memcpy(tm, &rtc->alarm_time, sizeof(struct rtc_time));
> 	else
> 		rtc->rtc_sync = false;
>
>_

Yep: 
+ rtc-da9063-rtc-driver.patch added to -mm tree
+ rtc-da9063-rtc-driver-fix.patch added to -mm tree

Looks great.
Thanks for reviewing, fixing and merging 

Regards
Steve

