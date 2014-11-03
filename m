Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKCMRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:17:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:51549 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaKCMRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:17:36 -0500
Message-ID: <54577258.9080508@linutronix.de>
Date: Mon, 03 Nov 2014 13:17:28 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Griffis, Brad" <bgriffis@ti.com>, "R, Vignesh" <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <544E821D.5040004@linutronix.de> <912A29987EAE174BA6CF187D7CDFA9CE26F46B2B@DLEE08.ent.ti.com>
In-Reply-To: <912A29987EAE174BA6CF187D7CDFA9CE26F46B2B@DLEE08.ent.ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 08:02 PM, Griffis, Brad wrote:
> On 10/27/2014 12:34 PM, Sebastian Andrzej Siewior wrote:
>> Do we really need #3 (and then #4)? Given the complexity we have already, is there any benefit by decreasing this value? 
> 
> I specifically requested we add ti,charge-delay to the device tree because it is THE critical value to tune for a given design.  Although I think the current value of 0xB000 will be suitable for a great many designs, I expect that many users will need to adjust this value for their hardware.  Details such as which touchscreen vendor is being used and how the touchscreen is connected (header vs cable) have an effect on what's appropriate here.

Oh. That is one knob I hoped we could avoid since I haven't seen it
before on other TSCs. But okay. Please make sure that there is a
message printed if the default value is used. And lets hope the user
will do something about his.

>> Would  someone want to increase it? Can we safely determine a value which works for everyone?
> 
> This value represents a hardware delay before checking for the pen-up event.  So in the scenario where someone is seeing excessive false pen-up events they will want to increase this parameter.  The downsize of making this larger is that it decreases the overall sampling speed of both the touchscreen as well as the standalone ADC samples.  At one point I tried making it huge, but that made the touchscreen overly sluggish because the sampling became too slow.  So there is a definite trade-off that if you make it too large the touchscreen becomes sluggish, and if you make it too small then you may see false pen-up events.  The optimal value will need to be tuned for a given design.

I applied the patches from this series and did the following test on my
am335x-evm: A mug on the touchscreen (to make sure the events are
coming), evtest on the event node to see that the events and loop of

	cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw

In the past I was able lock up the TSC/ADC HW that way (see commit
7ca6740cd1 ("mfd: input: iio: ti_amm335x: Rework TSC/ADC
synchronization")) for details.
With this patches applied I don't seen any TSC events once the IIO
interface is (heavily) used. Can this be fixed?

Sebastian
