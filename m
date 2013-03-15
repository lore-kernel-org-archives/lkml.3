Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3COFJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:09:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38522 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3COFJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:09:13 -0400
Message-ID: <5142ACEA.4060305@ti.com>
Date: Fri, 15 Mar 2013 10:38:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: Re: [PATCH 2/3] ARM: davinci: da850: Enable EHRPWM TBCLK from CFG_CHIP1
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com> <1363257453-24747-3-git-send-email-avinashphilip@ti.com> <5141CA40.9010005@ti.com> <518397C60809E147AF5323E0420B992E3EA97355@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA97355@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/2013 10:27 AM, Philip, Avinash wrote:
> On Thu, Mar 14, 2013 at 18:31:52, Nori, Sekhar wrote:
>> On 3/14/2013 4:07 PM, Philip Avinash wrote:
>>> da850 platforms require TBCLK synchronization in CFG_CHIP1 register for
>>> TBCLK enable in EHRPWM modules. Enabling of TBCLK is done only if EHRPWM
>>> DT node status is set to "okay" DT blob.
>>> Also adds macro definitions for DA8XX_EHRPWM_TBCLKSYNC and
>>> DA8XX_CFGCHIP1_REG.
>>
>> So there is actually a TBCLK in DA850 - it's just not modeled as a clock
>> similar to the way it is done on AM335x? If yes, then instead of adding
>> a dummy clock node and doing the TBCLK enable as part of init, why not
>> model TBCLK in clock tree even on DA850?
> 
> 
> TBCLK enabling should done from platform specific way. In DA850 it is done at
> CFGCHIP1 register. Unfortunately Davinci clock frame work will support only
> clock nodes inside PLLC and PSC modules. Handling of CFGCHP1 require

That's true at the moment, but that can be fixed.

> modifications in clock frame work.
> 
> Hence handling it as part of initialization.

I am curious as to how this clock is handled in am335x. I searched for
tbclk in arch/arm/ of linux-next but could not find any references.
Where should I be looking?

Thanks,
Sekhar
