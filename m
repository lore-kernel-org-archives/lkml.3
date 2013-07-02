Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3GBGLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:11:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48552 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab3GBGLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:11:53 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "khilman@linaro.org" <khilman@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 3/4] rtc: omap: add rtc wakeup support to alarm events
Thread-Topic: [PATCH 3/4] rtc: omap: add rtc wakeup support to alarm events
Thread-Index: AQHOc+J3RdUEBUL1FkS6xaDIitR2t5lQZZwAgACGXFD//3uRAIAAhkcA
Date: Tue, 2 Jul 2013 06:11:01 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC4E7CC@DBDE04.ent.ti.com>
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
 <1372412109-986-4-git-send-email-gururaja.hebbar@ti.com>
 <51D26CFA.5090500@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EC4E7AB@DBDE04.ent.ti.com>
 <51D26E98.9040303@ti.com>
In-Reply-To: <51D26E98.9040303@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r626Bxin005861

On Tue, Jul 02, 2013 at 11:39:28, Nori, Sekhar wrote:
> On 7/2/2013 11:34 AM, Hebbar, Gururaja wrote:
> > On Tue, Jul 02, 2013 at 11:32:34, Nori, Sekhar wrote:
> >> On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
> >>> On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> >>> is available to enable Alarm Wakeup feature. This register needs to be
> >>> properly handled for the rtcwake to work properly.
> >>>
> >>> Platforms using such IP should set "ti,am3352-rtc" in rtc device dt
> >>> compatibility node.
> >>>
> >>> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> >>> Cc: Grant Likely <grant.likely@linaro.org>
> >>> Cc: Rob Herring <rob.herring@calxeda.com>
> >>> Cc: Rob Landley <rob@landley.net>
> >>> Cc: Sekhar Nori <nsekhar@ti.com>
> >>> Cc: Kevin Hilman <khilman@linaro.org>
> >>> Cc: Alessandro Zummo <a.zummo@towertech.it>
> >>> Cc: rtc-linux@googlegroups.com
> >>> Cc: devicetree-discuss@lists.ozlabs.org
> >>> Cc: linux-doc@vger.kernel.org
> >>> ---
> >>
> >> [...]
> >>
> >>> -#define	OMAP_RTC_DATA_DA830_IDX	1
> >>> +#define	OMAP_RTC_DATA_DA830_IDX		1
> >>> +#define	OMAP_RTC_DATA_AM335X_IDX	2
> >>>  
> >>>  static struct platform_device_id omap_rtc_devtype[] = {
> >>>  	{
> >>> @@ -309,6 +321,9 @@ static struct platform_device_id omap_rtc_devtype[] = {
> >>>  	}, {
> >>>  		.name	= "da830-rtc",
> >>>  		.driver_data = OMAP_RTC_HAS_KICKER,
> >>> +	}, {
> >>> +		.name	= "am335x-rtc",
> >>
> >> may be use am3352-rtc here just to keep the platform device name and of
> >> compatible in sync.
> > 
> > Correct. I will update the same in v2.
> > 
> >>
> >>> +		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN,
> >>>  	},
> >>>  	{},
> >>
> >> It is better to use the index defined above in the static initialization
> >> so they remain in sync.
> > 
> > Sorry. I didnâ€™t get this.
> > 
> 
> See example below I provided. If its still not clear, let me know what
> is not clear.
> 
> >> 	...
> >> 	[OMAP_RTC_DATA_DA830_IDX] = {
> >> 		.name	= "da830-rtc",
> >> 		.driver_data = OMAP_RTC_HAS_KICKER,
> >> 	},

Thanks for the clarification. In this case will it ok if I update the previous
member also.

> 
> Thanks,
> Sekhar
> 


Regards, 
Gururaja
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
