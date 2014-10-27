Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaJ0TMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:12:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39137 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaJ0TEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:01 -0400
From: "Griffis, Brad" <bgriffis@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "R, Vignesh" <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Benoit Cousson" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Lee Jones" <lee.jones@linaro.org>, "Balbi, Felipe" <balbi@ti.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RE: [PATCH 0/4] Touchscreen performance related fixes
Thread-Topic: [PATCH 0/4] Touchscreen performance related fixes
Thread-Index: AQHP8dZoHcZIwJ20/EatfN2XMfiHy5xEiKCA///AuBA=
Date: Mon, 27 Oct 2014 19:02:47 +0000
Message-ID: <912A29987EAE174BA6CF187D7CDFA9CE26F46B2B@DLEE08.ent.ti.com>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
 <544E821D.5040004@linutronix.de>
In-Reply-To: <544E821D.5040004@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 12:34 PM, Sebastian Andrzej Siewior wrote:
> Do we really need #3 (and then #4)? Given the complexity we have already, is there any benefit by decreasing this value? 

I specifically requested we add ti,charge-delay to the device tree because it is THE critical value to tune for a given design.  Although I think the current value of 0xB000 will be suitable for a great many designs, I expect that many users will need to adjust this value for their hardware.  Details such as which touchscreen vendor is being used and how the touchscreen is connected (header vs cable) have an effect on what's appropriate here.

> Would  someone want to increase it? Can we safely determine a value which works for everyone?

This value represents a hardware delay before checking for the pen-up event.  So in the scenario where someone is seeing excessive false pen-up events they will want to increase this parameter.  The downsize of making this larger is that it decreases the overall sampling speed of both the touchscreen as well as the standalone ADC samples.  At one point I tried making it huge, but that made the touchscreen overly sluggish because the sampling became too slow.  So there is a definite trade-off that if you make it too large the touchscreen becomes sluggish, and if you make it too small then you may see false pen-up events.  The optimal value will need to be tuned for a given design.

