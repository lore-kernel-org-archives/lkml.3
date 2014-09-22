Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaIVBCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 21:02:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39469 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaIVBCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 21:02:07 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Hartmut Knaack <knaack.h@gmx.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Angelo Compagnucci" <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        "Johannes Thumshirn" <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        "Josh Cartwright" <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "David Collins" <collinsd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: RE: [PATCH v2 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
Thread-Topic: [PATCH v2 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
Thread-Index: AQHP1aAelxktd+4Ys02WPQc9e32zY5wMSPVQ
Date: Mon, 22 Sep 2014 01:01:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FBC4743E2@DQHE06.ent.ti.com>
References: <1410448403-19402-1-git-send-email-svarbanov@mm-sol.com>
 <1410448403-19402-2-git-send-email-svarbanov@mm-sol.com>
 <54138151.8010902@gmx.de> <54147E97.60808@kernel.org>
 <5416F3E2.3030009@mm-sol.com>
 <4dbc485f-599a-4b50-854c-c2e1c44d4810@email.android.com>
 <541AAC80.1090708@mm-sol.com> <541ED2C0.4040801@kernel.org>
In-Reply-To: <541ED2C0.4040801@kernel.org>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8M12FKB025421

Hello Jonathan and Stanimir,

> >> See Documentation/ABI/sysfs-bus-iio
> >> Millivolts I think... We copied hwmon where possible.
> >
> > I'm a bit confused about these units. I searched references of
> > iio_read_channel_processed() and found a few.
> >
> > The iio_hwmon expecting milivolts. On the other side lp8788-charger.c
> > registers a get_property method in charger-manager.c, which expects
> > microvolts in get_batt_uV().
> It's definitely meant to be millivolts (lifted from hwmon a while back).
> See Documentation/ABI/testing/sysfs-bus-iio
> 
> Looks like we have a bug in lp8788-charger - it might be matched with one in
> lp8788-adc, but then there will be a bug there...
> 
> Cc'd Milo Kim.

'lp8788-charger' registers not charger-manager but power-supply subsystem.
'lp8788-adc' is the IIO driver.
'lp8788-charger' is the IIO consumer of lp8788-adc.

(How to communicate between lp8788-adc and lp8788-charger)
1. Application requests vbatt(battery voltage) by accessing /sys/class/power/
2. lp8788-charger asks lp8788-adc to get converted vbatt value
3. lp8788-adc get the battery ADC from the device.
   It returns calculated micro voltage to lp8788-charger.
4. lp8788-charger reports this uV value to the application
5. Application uses uV or converts to mV or V unit. It's up to the app.

Please note that battery app accesses not /sys/bus/iio but /sys/class/power/.

Best regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
