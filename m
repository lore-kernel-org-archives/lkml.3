Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaCEQUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:20:07 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.141]:25926 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbaCEQUF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:20:05 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-5.tower-180.messagelabs.com!1394036403!29273731!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Alessandro Zummo <a.zummo@towertech.it>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: RE: [RFC V1 2/2] rtc: da9063: RTC driver
Thread-Topic: [RFC V1 2/2] rtc: da9063: RTC driver
Thread-Index: AQHPOIlTzlEM1gazP0aPdymXTYluDprSqWeQ
Date: Wed, 5 Mar 2014 16:20:01 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A0C6027B@NB-EX-MBX02.diasemi.com>
References: <cover.1394022316.git.stwiss.opensource@diasemi.com>
	<649fad1df15ee9f79655bc109282a21e9e9810cf.1394022316.git.stwiss.opensource@diasemi.com>
 <20140305164102.1f8644e4@linux.lan.towertech.it>
In-Reply-To: <20140305164102.1f8644e4@linux.lan.towertech.it>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.50.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On: 05 March 2014 15:41 Alessandro Zummo [mailto:a.zummo@towertech.it] wrote

>-----Original Message-----
>From: Alessandro Zummo [mailto:a.zummo@towertech.it]
>Sent: 05 March 2014 15:41
>
>On Wed, 5 Mar 2014 12:25:16 +0000
>"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:
>
>> +	if (IS_ERR(rtc->rtc_dev)) {
>> +		ret = PTR_ERR(rtc->rtc_dev);
>> +		goto err;
>> +	}
>
> please,
>
>  return PTR_ERR(....)
>

Yes, thanks, I'll make that change

>> +
>> +	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
>> +	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
>> +					da9063_alarm_event,
>> +					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>> +					"ALARM", rtc);
>> +	if (ret)
>> +		dev_err(&pdev->dev, "Failed to request ALARM IRQ %d: %d\n",
>> +			irq_alarm, ret);
>> +
>> +	da9063_data_to_tm(data, &rtc->alarm_time);
>> +	rtc->rtc_sync = false;
>> +err:
>> +	return ret;
>> +}
>
>   if the interrupt is mandatory you should request it before registering
>  the rtc device. if it isn't, please return 0.

I will make that change also and resubmit later.
Thank you for your quick response.

Regards
Steve
