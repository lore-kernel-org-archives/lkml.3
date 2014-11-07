Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaKGIAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:00:52 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47833 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaKGIAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:00:45 -0500
Date: Fri, 7 Nov 2014 09:00:34 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jan Kardell <jan.kardell@telliq.com>, linux-iio@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Meerwald <pmeerw@pmeerw.net>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Brad Griffis <bgriffis@ti.com>
Subject: Re: [PATCH 1/4] input: touchscreen: ti_am335x_tsc Interchange
 touchscreen and ADC steps
Message-ID: <20141107080033.GA6455@netboy>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
 <1414408111-2631-2-git-send-email-vigneshr@ti.com>
 <20141106141916.GA17151@netboy>
 <545C59CD.3070707@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545C59CD.3070707@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:04:05AM +0530, Vignesh R wrote:
> 
> Currently, there is too much noise in the TSC hardware that is being
> removed by delta filtering.

The so called "filter" was only programmed because the fifo entries
were being mixed up. Sebastian fixed that.

> I tested TSC unit by removing filtering
> logic, the performance was not at all satisfactory. The cursor jumps
> wayward and smooth circles cannot be drawn. Looks like delta filtering
> cannot be removed as of now. May be I will try and address it in future.

The "filter" code is nonsensical. It picks the two values in seqeunce
that are closest to one and another. How is that supposed to work?

Did you look at the "noise"? What kind of properties did you see?

A median filter makes more sense. Or sort, remove outliers, and
average. But choosing the two closest in series is silly.

Thanks,
Richard
