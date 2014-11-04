Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaKDMhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:37:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:59534 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKDMh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:37:29 -0500
Message-ID: <5458C87F.80409@linutronix.de>
Date: Tue, 04 Nov 2014 13:37:19 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Vignesh R <vigneshr@ti.com>, "Griffis, Brad" <bgriffis@ti.com>,
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
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <544E821D.5040004@linutronix.de> <912A29987EAE174BA6CF187D7CDFA9CE26F46B2B@DLEE08.ent.ti.com> <54577258.9080508@linutronix.de> <5458BC0B.1040803@ti.com>
In-Reply-To: <5458BC0B.1040803@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 12:44 PM, Vignesh R wrote:

> I ran following commands
> $ evtest /dev/input/touchscreen0 &
> (with heavy item on touchscreen)
>  and
> $ cat /sys/bus/iio/devices/iio\:device0/scan_elements/in_voltage4_en
> (in a busy loop)
> I tried above experiment on my board but I didn't hit any problem even
> after running for close to 30 minutes. I was unable to reproduce failure

Just to make sure: You had the touchscreen and iio command running in
parallel and you saw evtest output while there was iio operation?

> The problem may be in configuring correct charge-delay value. Please run:
> $ ts_test > /dev/null
> and let me know if pen events are being detected properly.

Well I get the touch events but not while busy loop on iio interface is
running (I get maybe one event every 5 seconds or so).
After all, it is the same HW you have.

Sebastian
