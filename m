Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbaKTN5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:57:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40114 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaKTN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:57:27 -0500
Message-ID: <546DF2F0.9080405@ti.com>
Date: Thu, 20 Nov 2014 19:26:00 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Vignesh R <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <richardcochran@gmail.com>,
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
        <linux-input@vger.kernel.org>, Robert Nelson <robertcnelson@gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache
 save
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com> <1415941651-28962-4-git-send-email-vigneshr@ti.com> <20141118143005.GF24004@x1> <20141118171240.GB3003@dtor-ws>
In-Reply-To: <20141118171240.GB3003@dtor-ws>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 10:42 PM, Dmitry Torokhov wrote:
> On Tue, Nov 18, 2014 at 02:30:05PM +0000, Lee Jones wrote:
>> On Fri, 14 Nov 2014, Vignesh R wrote:
>>
>>> In one shot mode, sequencer automatically disables all enabled steps at
>>> the end of each cycle. (both ADC steps and TSC steps) Hence these steps
>>> need not be saved in reg_se_cache for clearing these steps at a later
>>> stage.
>>> Also, when ADC wakes up Sequencer should not be busy executing any of the
>>> config steps except for the charge step. Previously charge step was 1 ADC
>>> clock cycle and hence it was ignored.
>>>
>>> Signed-off-by: Vignesh R <vigneshr@ti.com>
>>> ---
>>>  drivers/mfd/ti_am335x_tscadc.c       | 7 +++++--
>>>  include/linux/mfd/ti_am335x_tscadc.h | 1 +
>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> Code looks better now.
>>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>>
>> What's the plan for this series?
> 
> I am waiting for the interested parties to provide more feedback. So far
> I have seen a few reports saying that they see issues with the series
> applied.

I tested this using lcd7 cape connected to beaglebone black. The latest
kernel I could find on this board was a TI BSP based v3.14 kernel. So I
had to port these patches to that kernel. Cc Robert Nelson to see if he
knows about a more recent kernel supporting that cape.

I did not see any breakage with these patches applied although I did not
see any noticeable performance improvement as well.

I also tested along with continuous loop reading from
/sys/bus/iio/devices/iio:device0/in_voltage5_raw

I have pushed the kernel I used here in case anyone wants to take a look
at my porting.

http://git.ti.com/cgit/cgit.cgi/~nsekhar/ti-linux-kernel/nsekhar-ti-linux-kernel.git/log/?h=am335x-tsc-test

I also tested this series on AM335x EVM using the v3.18-rc5 kernel.
Again, no breakage but no improvement as well.

All testing was done using ts_test

FWIW, you can add:

Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
