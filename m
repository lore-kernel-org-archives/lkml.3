Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaKQE2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 23:28:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56026 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaKQE2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 23:28:34 -0500
Message-ID: <54697919.5030302@ti.com>
Date: Mon, 17 Nov 2014 09:57:05 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [PATCH v4 2/6] input: touchscreen: ti_am335x_tsc: Remove udelay
 in interrupt handler
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com> <1415941651-28962-3-git-send-email-vigneshr@ti.com> <20141115192739.GA18766@localhost.localdomain>
In-Reply-To: <20141115192739.GA18766@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sunday 16 November 2014 12:57 AM, Richard Cochran wrote:
> On Fri, Nov 14, 2014 at 10:37:27AM +0530, Vignesh R wrote:
>> From: Brad Griffis <bgriffis@ti.com>
>>
>> TSC interrupt handler had udelay to avoid reporting of false pen-up
>> interrupt to user space. This patch implements workaround suggesting in
>> Advisory 1.0.31 of silicon errata for am335x, thus eliminating udelay
>> and touchscreen lag. This also improves performance of touchscreen and
>> eliminates sudden jump of cursor at touch release.
> 
> I back ported this series onto v3.15.1 in order to try this out on a
> custom, beaglebone-like board. With this series, the touch is really
> broken. (I had fixed the pen up problem in a totally different way for
> a customer, and so I wanted to try out your solution.)
> 
> I will try to port the board code to a more recent kernel to try your
> series again. With which kernel version did you test your patches?
> 
> And which board?
> 
Thanks for testing these patches.

My patches are based on v3.18rc2. I tested my patches on am335x-evm
using tslib.
If you are encountering false pen-ups, charge-delay parameter needs to
be tuned to your board. In some custom setups charge-delay of 0xB000
provided better performance.
If you are using ts_test (from tslib) for testing try
# ts_test > /dev/null
for better performance.

Please explain "touch is broken"? What is the behaviour of TSC?
Which ADC channels are being used for TSC?

Regards
Vignesh

> Thanks,
> Richard
> 
> 
