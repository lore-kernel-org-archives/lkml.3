Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaA2XdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:33:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58753 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaA2XdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:33:09 -0500
Message-ID: <52E98F99.2050600@ti.com>
Date: Wed, 29 Jan 2014 17:32:41 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Robert Nelson <robertcnelson@gmail.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>, <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: OMAP3+: add clock nodes for CPU
References: <1391019557-22313-1-git-send-email-nm@ti.com>	<1391019557-22313-3-git-send-email-nm@ti.com> <CAOCHtYjaCBn2oOk66ef9wiz_GJnVwHDyx446_mrkipPoENaeUQ@mail.gmail.com>
In-Reply-To: <CAOCHtYjaCBn2oOk66ef9wiz_GJnVwHDyx446_mrkipPoENaeUQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 01:29 PM, Robert Nelson wrote:
> On Wed, Jan 29, 2014 at 12:19 PM, Nishanth Menon <nm@ti.com> wrote:
>> OMAP34xx, AM3517 and OMAP36xx platforms use dpll1 clock.
>>
>> OMAP443x, OMAP446x, OMAP447x, OMAP5, DRA7, AM43xx platforms use
>> dpll_mpu clock.
>>
>> Latency used is the generic latency defined in omap-cpufreq
>> driver.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Hi Nishanth,
> 
> After this patch, do you see any limitation to finally enabling 1Ghz
> operation on the beagle-xm by default? Or are we still missing a
> dependicy somewhere?

yes, there is:
a) ABB dt series - i will repost this in a few mins
b) AVS conversion from non-dt mode to dt supported mode. (which by
itself depends on VC/VP conversion).
c) clk notifier based dvfs for cpufreq-cpu0 -> this allows us to
introduce the necessary plumbing for mpu voltage domain such that the
TWL4030 regulator, AVS and ABB are rightly sequenced.

What you have done in the patch below is to introduce ABB regulator -
but no one is actually using it -> this might actually work on certain
samples at 1GHz, but prolonged operation will either damage the device
or fail on other samples - I have tried numerous times Internally to
get approval for non ABB/AVS configuration for 1GHz - but I have a
clear feedback that it cannot be done with the constraints of
DM3730/OMAP3630.

Lets do this a series at a time and build up the necessary support -
we get clock nodes for dvfs (using i2c1) here with cpufreq-cpu0 with
this series. If folks can ack and queue this up, we can get in ABB dts
nodes in place - allowing us to work on the next set -> sequencing
using clock notifier. in parallel we could work on converting AVS back
to dt based solution.

yes, the road is long.

-- 
Regards,
Nishanth Menon
