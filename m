Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3C1UJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:09:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31279 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3C1UJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:09:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,367,1363158000"; 
   d="scan'208";a="33590450"
Message-ID: <5154A37B.1070407@codeaurora.org>
Date: Thu, 28 Mar 2013 13:09:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-4-git-send-email-sboyd@codeaurora.org> <20130328152255.GD30477@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130328152255.GD30477@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/13 08:22, Mark Rutland wrote:
> This works on my A9x4 coretile, bringing CPUs up and down via
> /sys/devices/system/cpu/*/online, so:
>
> Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks. I still need to resolve patch #1 though.

>
> Otherwise, is there any reason we couldn't now use the twd driver on a UP
> system? Or would the overhead of handling frequency change make this pointless?

I don't see why not but I don't have any interest in pursuing it.

>
> On Wed, Mar 13, 2013 at 06:17:49PM +0000, Stephen Boyd wrote:
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 5b71469..5ad2ccf 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1527,6 +1527,7 @@ config SMP
>>  	depends on HAVE_SMP
>>  	depends on MMU
>>  	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
>> +	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
> Could you not depend on your "Push selects for TWD/SCU into machine entries"
> for this?

Right now the patches don't depend on the push down patch. Are you
saying it would be better to depend on that patch?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

