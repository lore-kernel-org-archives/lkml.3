Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaIRNun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:50:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53412 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaIRNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:50:42 -0400
Message-ID: <541AE314.5040107@ti.com>
Date: Thu, 18 Sep 2014 08:50:12 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Kristo, Tero" <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J, KEERTHY" <j-keerthy@ti.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
References: <1408716154-26101-1-git-send-email-nm@ti.com> <1408716154-26101-9-git-send-email-nm@ti.com>,<5419D7BD.30003@linaro.org> <448912EABC71F84BBCADFD3C67C4BE52CAC748@DBDE04.ent.ti.com> <541A25DA.8030101@linaro.org> <541AE102.2070407@ti.com>
In-Reply-To: <541AE102.2070407@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 08:41 AM, Nishanth Menon wrote:
> On 09/17/2014 07:22 PM, Daniel Lezcano wrote:
>> On 09/17/2014 04:20 PM, Shilimkar, Santosh wrote:
> [...]
>>> Could you try a long run of this little program:
>>>
>>> https://git.linaro.org/power/pm-qa.git/blob/HEAD:/cpuidle/cpuidle_killer.c
>>>
>>> [Santosh] I am sure there will not be any issue with the long run test case here.
>>> Lets see if Nishant sees anything otherwise
>>
>> Ok. Make sure the cpu is effectively entering your C2 state with the 
>> sleep duration in the test program.
> 
> Test kernel:
> https://github.com/nmenon/linux-2.6-playground/commits/testing/tmlind-test-suspend-resume
> (I decided to merge in various send for pull branches from maintainers
> and apply cpuidle on top)..
> 
> Controlled test run as follows on 4 different impacted platforms and 1
> platform as legacy reference.
> 
> What we are looking for is
>> cpu1_pwrdm (ON),OFF:0,RET:2677,INA:0,ON:2678,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> RET:2677 indicated CPU1 hit C2
>> cpu0_pwrdm (ON),OFF:0,RET:2677,INA:0,ON:2678,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
> RET:2677 indicated CPU0 hit C2
>> mpu_pwrdm (ON),OFF:0,RET:2667,INA:0,ON:2668,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:2667,RET-MEMBANK2-OFF:0
> RET:2667 indicates that CPU0 and CPU1 managed to achieve RET together,
> else by hardware constraints in place, MPU power domain will fail to
> transition.
> 
> What I see in all cases below is that transitions do take place (C2 is
> successfully hit).
> 
> Test #1: 120 seconds:
> CMD: set -x;uname -a;cat /sys/kernel/debug/pm_debug/count;sleep
> 1;./cpuidle_killer_120;sleep 1;cat /sys/kernel/debug/pm_debug/count;set +x
> 
> OMAP4 Panda-ES: (2 a9) - not impacted as part of this patch - just
> base test vector
> http://fpaste.org/134547/14110454/
> 
> OMAP5 uEVM: (2 a15)
> http://fpaste.org/134546/10454181/
> 
> DRA74x: (2 a15)
> http://fpaste.org/134543/11045286/
> 
> DRA72: (2 a15)
	  ^^
Correction should have been 1 a15

> http://fpaste.org/134544/11045335/
> 
> AM572x(DRA74x variant): (2 A15)
> http://fpaste.org/134545/10453761/
> 
> 
> Test #2: 1200 seconds: (http://fpaste.org/134564/47289141/)
> CMD: set -x;uname -a;cat /sys/kernel/debug/pm_debug/count;sleep
> 1;./cpuidle_killer_1200;sleep 1;cat
> /sys/kernel/debug/pm_debug/count;set +x
> 
> OMAP4 Panda-ES: (2 a9) - not impacted as part of this patch - just
> base test vector
> http://fpaste.org/134563/41104728/
> 
> OMAP5 uEVM: (2 a15)
> http://fpaste.org/134562/47221141/
> 
> DRA74x EVM: (2 a15)
> http://fpaste.org/134559/11047098/
> 
> DRA72 EVM: (2 a15)
	      ^^
Correction should have been 1 a15

> http://fpaste.org/134560/11047151/
> 
> AM572x EVM: (2 A15)
> http://fpaste.org/134561/47189141/
> 
> 


-- 
Regards,
Nishanth Menon
