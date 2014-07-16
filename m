Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013AbaGPOQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:16:42 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:53130 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934388AbaGPOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:16:40 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53C68943.2060003@ladisch.de>
Date: Wed, 16 Jul 2014 16:16:35 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        John Stultz <john.stultz@linaro.org>, Mark Brown <broonie@linaro.org>
Subject: Re: firewire: CLOCK_MONOTONIC_RAW exposure
References: <alpine.DEB.2.10.1407161151450.24854@nanos> <53C6633D.9080905@ladisch.de> <20140716123727.GA19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140716123727.GA19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, Jul 16, 2014 at 01:34:21PM +0200, Clemens Ladisch wrote:
>> Thomas Gleixner wrote:
>>> I wonder why firewire exposed CLOCK_MONOTONIC_RAW to user space.
>>>
>>> What's the purpose of that? CLOCK_MONOTONIC_RAW is the raw time based
>>> on the initial frequency setup of the clocksource. That can be quite
>>> off from the NTP corrected frequency which is exposed by
>>> CLOCK_MONOTONIC.
>>
>> The purpose is to get a stable clock, i.e., to avoid clock rate changes
>> caused by NTP corrections.
>
> That's maybe half an answer; what do you need that for?

According to the original report, "for applications which need to
synchronise with external timebases such as broadcast TV applications".
Such external clocks are not synchronous with any available clocksource,
so proper resampling requires that the (relative) rate of the two clocks
(sender and playback device) is measured accurately.

(I don't have numbers for the errors caused by NTP adjustments.  Daniel?)


Regards,
Clemens
