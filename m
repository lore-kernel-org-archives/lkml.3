Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaD1NCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:02:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43284 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaD1NCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:02:03 -0400
Message-ID: <535E4FDC.70306@ti.com>
Date: Mon, 28 Apr 2014 18:25:56 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <davem@davemloft.net>,
        <jeffrey.t.kirsher@intel.com>, <dborkman@redhat.com>,
        <ast@plumgrid.com>, <tklauser@distanz.ch>, <mpa@pengutronix.de>,
        <bhutchings@solarflare.com>, <zonque@gmail.com>, <balbi@ti.com>,
        <mugunthanvnm@ti.com>, <t-kristo@ti.com>, <mturquette@linaro.org>,
        <linux@arm.linux.org.uk>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH 5/6] ARM: AM43xx: clk: Change the cpts ref clock source
 to dpll_core_m5 clk
References: <1398658225-25873-1-git-send-email-george.cherian@ti.com> <1398658225-25873-6-git-send-email-george.cherian@ti.com> <20140428071034.GB4380@netboy>
In-Reply-To: <20140428071034.GB4380@netboy>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 12:40 PM, Richard Cochran wrote:
> On Mon, Apr 28, 2014 at 09:40:24AM +0530, George Cherian wrote:
>> cpsw_cpts_rft_clk has got the choice of 3 clocksources
>>   -dpll_core_m4_ck
>>   -dpll_core_m5_ck
>>   -dpll_disp_m2_ck
>>
>> By default dpll_core_m4_ck is selected, witn this as clock
>> source the CPTS doesnot work properly. It gives clockcheck errors
>> while running PTP.
>>
>>   clockcheck: clock jumped backward or running slower than expected!
> It is strange that I have never seen this error, since I have often
> tested linuxptp on a beagle bone white.
In beagle bone white (AM335x)  CPTS has a choice of 2 clocksource
-dpll_core_m5_ck
-dpll_core_m4_ck
and by default  dpll_core_m5_ck is used. Where as in AM437x the default 
clocksource used is dpll_core_m4_ck .

You can change the clocksource in beagle bone white by writing  1 to 
0x44e00520 (By default its 0).
>
> Can you please explain why this clock doesn't work correctly?
>
>> By selecting dpll_core_m5_ck as the clocksource fixes this issue.
>> In AM335x dpll_core_m5_ck is the default clocksource.
> The choice of clock source in the CPTS driver originally came from
> TI. It would be nice to know why that was the wrong choice.
>
> Thanks,
> Richard


-- 
-George

