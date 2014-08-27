Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760AbaH0TFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:05:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58942 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935477AbaH0TFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:05:48 -0400
Message-ID: <53FE2BF2.3020006@ti.com>
Date: Wed, 27 Aug 2014 14:05:22 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
Subject: Re: [PATCH 07/10] ARM: OMAP5 / DRA7: Enable CPU RET on suspend
References: <1408716154-26101-1-git-send-email-nm@ti.com>	<1408716154-26101-8-git-send-email-nm@ti.com> <7hbnr5dake.fsf@paris.lan>
In-Reply-To: <7hbnr5dake.fsf@paris.lan>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 01:58 PM, Kevin Hilman wrote:
> Nishanth Menon <nm@ti.com> writes:
> 
>> From: Rajendra Nayak <rnayak@ti.com>
>>
>> On OMAP5 / DRA7, prevent a CPU powerdomain OFF and resulting MPU OSWR
>> and instead attempt a CPU RET and side effect, MPU RET in suspend.
>>
>> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
>> [nm@ti.com: update to do save_state only on DRA7]
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap-mpuss-lowpower.c |    4 ++++
>>  arch/arm/mach-omap2/omap-wakeupgen.c      |    2 +-
>>  arch/arm/mach-omap2/pm44xx.c              |    9 +++++++--
>>  3 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
>> index 207fce2..0d640eb 100644
>> --- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
>> +++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
>> @@ -242,6 +242,10 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
>>  		save_state = 1;
>>  		break;
>>  	case PWRDM_POWER_RET:
>> +		if (soc_is_omap54xx() || soc_is_dra7xx()) {
> 
> Aren't we trying to get away from these soc_* checks for anything other
> than init code?

I would expect that to take place in stages as part of which the next
level of cleanup is to move PRM into drivers. Currently our wakeupgen,
prm code does have quiet a few needs of dealing with soc_is checks
primarily from having to re-architect code in two different directions
- we want to move into just one direction eventually - to prm drivers
and as less code in mach-omap2 which is already in the works.


-- 
Regards,
Nishanth Menon
