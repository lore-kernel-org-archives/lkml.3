Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3GOLKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:10:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57110 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3GOLKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:10:38 -0400
From: "Kozaruk, Oleksandr" <oleksandr.kozaruk@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "ch.naveen@samsung.com" <ch.naveen@samsung.com>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Kim, Milo" <Milo.Kim@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
Thread-Topic: [PATCH v3 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC
 driver
Thread-Index: AQHOfznlQz/LbRwjPkm/a2+YYG7+MZlibVf+
Date: Mon, 15 Jul 2013 11:09:40 +0000
Message-ID: <2A7ABDFCE21540479A5AEB0244A684D5E3D067@DNCE04.ent.ti.com>
References: <1373613482-28390-1-git-send-email-oleksandr.kozaruk@ti.com>
 <1373613482-28390-3-git-send-email-oleksandr.kozaruk@ti.com>,<51E05F6C.1060506@metafoo.de>
In-Reply-To: <51E05F6C.1060506@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.92]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lars-Peter,
Thank you for the review.

>> diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
>> new file mode 100644
>> index 0000000..6ceb789
>> --- /dev/null
>> +++ b/drivers/iio/adc/twl6030-gpadc.c
>> @@ -0,0 +1,1019 @@
>[...]
>> +static u8 twl6032_channel_to_reg(int channel)
>> +{
>> +     return TWL6032_GPADC_GPCH0_LSB;
>
>There is more than one channel, isn't there?
Yes. But for twl6032 channel of interest is chosen first. When the conversion
is ready tre result is available in GPCH0_LSB/GPCH1_MSB for any cosen
channel. For twl6030 there are as many result register pairs as many of
channels.

>> +     ret = devm_request_threaded_irq(dev, irq, NULL,
>> +                                     twl6030_gpadc_irq_handler,
>> +                                     IRQF_ONESHOT, "twl6030_gpadc", gpadc);
>
>You access memory in the interrupt handler which is freed before the interrupt
>handler is freed.
Thanks for pointing this. devm_* will free memory for irq after the driver
is removed and memory for the device is freed. I took me awhile to understand
this. Is there going to be something like devm_iio_device_alloc? whould it be helpfull?