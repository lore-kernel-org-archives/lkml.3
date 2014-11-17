Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaKQMT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:19:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47762 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbaKQMTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:19:55 -0500
Message-ID: <5469E7A3.2000303@ti.com>
Date: Mon, 17 Nov 2014 17:48:43 +0530
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
>> The problem may be in configuring correct charge-delay value. Please run:
>> $ ts_test > /dev/null
>> and let me know if pen events are being detected properly.
> 
> Well I get the touch events but not while busy loop on iio interface is
> running (I get maybe one event every 5 seconds or so).
> After all, it is the same HW you have.

Were you able to test the latest version (v4) of this patch series?
Please let me know if the performance is satisfactory.

Regards
Vignesh

> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
