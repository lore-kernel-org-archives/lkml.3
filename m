Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKJKrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:47:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40321 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaKJKrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:47:46 -0500
Message-ID: <5460977E.9060604@ti.com>
Date: Mon, 10 Nov 2014 16:16:22 +0530
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
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <devicetree@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jan Kardell <jan.kardell@telliq.com>, <linux-iio@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Meerwald <pmeerw@pmeerw.net>, Hartmut Knaack <knaack.h@gmx.de>,
        <linux-omap@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, Brad Griffis <bgriffis@ti.com>
Subject: Re: [PATCH 1/4] input: touchscreen: ti_am335x_tsc Interchange touchscreen
 and ADC steps
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <1414408111-2631-2-git-send-email-vigneshr@ti.com> <20141106141916.GA17151@netboy> <545C59CD.3070707@ti.com> <20141107080033.GA6455@netboy>
In-Reply-To: <20141107080033.GA6455@netboy>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 07 November 2014 01:30 PM, Richard Cochran wrote:
> On Fri, Nov 07, 2014 at 11:04:05AM +0530, Vignesh R wrote:
>>
>> Currently, there is too much noise in the TSC hardware that is being
>> removed by delta filtering.
> 
> The so called "filter" was only programmed because the fifo entries
> were being mixed up. Sebastian fixed that.
> 
>> I tested TSC unit by removing filtering
>> logic, the performance was not at all satisfactory. The cursor jumps
>> wayward and smooth circles cannot be drawn. Looks like delta filtering
>> cannot be removed as of now. May be I will try and address it in future.
> 
> The "filter" code is nonsensical. It picks the two values in seqeunce
> that are closest to one and another. How is that supposed to work?
> 
> Did you look at the "noise"? What kind of properties did you see?
> 
> A median filter makes more sense. Or sort, remove outliers, and
> average. But choosing the two closest in series is silly.

I was able to implement median filter as you described and achieve
reliable performance. I will append that to this series of patches in v3.

Regards
Vignesh

> 
> Thanks,
> Richard
> 
