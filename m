Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaKEMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:09:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33384 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaKEMJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:09:54 -0500
Message-ID: <545A1343.4060002@ti.com>
Date: Wed, 5 Nov 2014 17:38:35 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Griffis, Brad" <bgriffis@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "Balbi, Felipe" <balbi@ti.com>, Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 0/4] Touchscreen performance related fixes
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <544E821D.5040004@linutronix.de> <912A29987EAE174BA6CF187D7CDFA9CE26F46B2B@DLEE08.ent.ti.com> <54577258.9080508@linutronix.de> <5458BC0B.1040803@ti.com> <5458C87F.80409@linutronix.de>
In-Reply-To: <5458C87F.80409@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 04 November 2014 06:07 PM, Sebastian Andrzej Siewior wrote:
> On 11/04/2014 12:44 PM, Vignesh R wrote:
> 
>> I ran following commands
>> $ evtest /dev/input/touchscreen0 &
>> (with heavy item on touchscreen)
>>  and
>> $ cat /sys/bus/iio/devices/iio\:device0/scan_elements/in_voltage4_en
>> (in a busy loop)
>> I tried above experiment on my board but I didn't hit any problem even
>> after running for close to 30 minutes. I was unable to reproduce failure
> 
> Just to make sure: You had the touchscreen and iio command running in
> parallel and you saw evtest output while there was iio operation?
> 

Yeah.. I see both evtest and IIO outputs. Touch events are received
consistently (decent samples per second) and atleast one IIO output per
second.
Here is a part from console log
---------------------------
928
Event: time 1413204484.240114, type 3 (Absolute), code 0 (X), value 1746
Event: time 1413204484.240114, type 3 (Absolute), code 1 (Y), value 1720
Event: time 1413204484.240114, type 3 (Absolute), code 24 (Pressure),
value 99
Event: time 1413204484.240114, -------------- Report Sync ------------
Event: time 1413204484.255318, type 1 (Key), code 330 (Touch), value 0
Event: time 1413204484.255318, type 3 (Absolute), code 24 (Pressure),
value 0
Event: time 1413204484.255318, -------------- Report Sync ------------
933
Event: time 1413204484.273599, type 3 (Absolute), code 1 (Y), value 1718
Event: time 1413204484.273599, type 3 (Absolute), code 24 (Pressure),
value 99
Event: time 1413204484.273599, type 1 (Key), code 330 (Touch), value 1
Event: time 1413204484.273599, -------------- Report Sync ------------
Event: time 1413204484.290195, type 3 (Absolute), code 24 (Pressure),
value 98
Event: time 1413204484.290195, -------------- Report Sync ------------
Event: time 1413204484.306783, type 3 (Absolute), code 1 (Y), value 1719
Event: time 1413204484.306783, -------------- Report Sync ------------
946
Event: time 1413204484.322164, type 1 (Key), code 330 (Touch), value 0
Event: time 1413204484.322164, type 3 (Absolute), code 24 (Pressure),
value 0
Event: time 1413204484.322164, -------------- Report Sync ------------
Event: time 1413204484.340435, type 3 (Absolute), code 1 (Y), value 1721
Event: time 1413204484.340435, type 3 (Absolute), code 24 (Pressure),
value 98
Event: time 1413204484.340435, type 1 (Key), code 330 (Touch), value 1
Event: time 1413204484.340435, -------------- Report Sync ------------
Event: time 1413204484.357025, type 3 (Absolute), code 0 (X), value 1745
Event: time 1413204484.357025, type 3 (Absolute), code 24 (Pressure),
value 97
Event: time 1413204484.357025, -------------- Report Sync ------------
Event: time 1413204484.373621, type 3 (Absolute), code 0 (X), value 1746
Event: time 1413204484.373621, type 3 (Absolute), code 1 (Y), value 1720
Event: time 1413204484.373621, -------------- Report Sync ------------
942

---------------------------
The numbers 928, 933 etc are from oneshot ADC read. The above output is
pretty consistent over time.

>> The problem may be in configuring correct charge-delay value. Please run:
>> $ ts_test > /dev/null
>> and let me know if pen events are being detected properly.
> 
> Well I get the touch events but not while busy loop on iio interface is
> running (I get maybe one event every 5 seconds or so).
> After all, it is the same HW you have.

Yeah.. I believe HW is same. I am using rev 1.5B with
omap2plus_defconfig (+ TSC/ADC enabled)

Regards
Vignesh
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
