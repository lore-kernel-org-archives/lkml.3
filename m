Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaDOHmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:42:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52973 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaDOHml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:42:41 -0400
Message-ID: <534CE2CB.5030503@ti.com>
Date: Tue, 15 Apr 2014 10:42:03 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Magnus Damm <magnus.damm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCHv2 07/11] ARM: OMAP3: Beagle: use PWM_LOOKUP to initialize
 struct pwm_lookup
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com> <1397512793-10325-8-git-send-email-alexandre.belloni@free-electrons.com> <534CD958.4000303@ti.com> <20140415071430.GA13659@verge.net.au>
In-Reply-To: <20140415071430.GA13659@verge.net.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:14 AM, Simon Horman wrote:
> On Tue, Apr 15, 2014 at 10:01:44AM +0300, Peter Ujfalusi wrote:
>> On 04/15/2014 12:59 AM, Alexandre Belloni wrote:
>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>> ---
>>>  arch/arm/mach-omap2/board-omap3beagle.c | 10 ++--------
>>>  1 file changed, 2 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
>>> index f27e1ec90b5e..54c135a5b4f7 100644
>>> --- a/arch/arm/mach-omap2/board-omap3beagle.c
>>> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
>>> @@ -61,14 +61,8 @@
>>>  
>>>  static struct pwm_lookup pwm_lookup[] = {
>>>  	/* LEDB -> PMU_STAT */
>>> -	{
>>> -		.provider = "twl-pwmled",
>>> -		.index = 1,
>>> -		.dev_id = "leds_pwm",
>>> -		.con_id = "beagleboard::pmu_stat",
>>> -		.period = 7812500,
>>> -		.polarity = PWM_POLARITY_NORMAL,
>>> -	},
>>> +	PWM_LOOKUP("twl-pwmled", 1, "leds_pwm", "beagleboard::pmu_stat",
>>> +		   7812500, PWM_POLARITY_NORMAL),
>>
>> Why do you need to do this in two steps?
>> In patch 4 you removed the existing PWM_LOOKUP() and now you are adding it back.
>> Would not be simpler if you just add the two new parameters in patch 4 (the
>> 812500, PWM_POLARITY_NORMAL)?
> 
> Such an approach would apply an atomic change to both the infrastructure
> and the users.

Yes, I overlooked patch 6...
Just ignore my comment.

-- 
Péter
