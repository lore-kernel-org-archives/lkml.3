Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaK0Ea7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 23:30:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52684 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaK0Eaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 23:30:55 -0500
Message-ID: <5476A8AD.4010003@ti.com>
Date: Thu, 27 Nov 2014 09:59:33 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] Touchscreen performance related fixes
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com> <20141124115116.GA14997@linutronix.de> <547321A2.6010207@ti.com> <547325FA.6020004@linutronix.de>
In-Reply-To: <547325FA.6020004@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 24 November 2014 06:05 PM, Sebastian Andrzej Siewior wrote:
> On 11/24/2014 01:16 PM, Vignesh R wrote:
> 
>> I have tried running both IIO and TSC at the same time. But I have never
>> seen WARN_ON() even after running for close to 30 min. Can you send me
>> the exact script, so that it will be easy to reproduce?
> 
> Sure thing.
> - one shell
> 	evtest /dev/input/event2
> - second shell
> 	./iio-test.sh
>   with:
> 
> |#!/bin/sh
> |
> |while [ 1 = 1 ]
> |do
> |        cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw
> |done
> 
> 
> the kernel config: https://breakpoint.cc/am335x-config
> 

I was able to reproduce this issue. When ADC hits WARN_ON(), the TSC
steps should be disabled. But, in this case, TSC is sampling the first Y
co-ordinate and all TSC steps are enabled.
REG_SE: 0x1ffc1
ADC_STAT: 0x24

Any idea why this may be happening?

Regards
Vignesh
