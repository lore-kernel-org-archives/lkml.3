Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbaBDXqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:46:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36406 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbaBDXqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:46:01 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2 1/5] ARM: msm: kill off hotplug.c
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140204230707.GD20528@codeaurora.org>
Date: Tue, 4 Feb 2014 17:45:56 -0600
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CE29C478-50CA-4CC8-9E80-AA9C22D9B17F@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org> <1391553532-27001-2-git-send-email-galak@codeaurora.org> <20140204230707.GD20528@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4, 2014, at 5:07 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 02/04, Kumar Gala wrote:
>> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
>> index 3721b31..251a91e 100644
>> --- a/arch/arm/mach-msm/platsmp.c
>> +++ b/arch/arm/mach-msm/platsmp.c
>> @@ -29,6 +29,13 @@ extern void secondary_startup(void);
>> 
>> static DEFINE_SPINLOCK(boot_lock);
>> 
>> +#ifdef CONFIG_HOTPLUG_CPU
>> +static void __ref msm_cpu_die(unsigned int cpu)
> 
> We shouldn't need __ref anymore either right?

I think we might as cpu_die is still marked __ref so I think we need it.

> 
>> +{
>> +	wfi();
>> +}
>> +#endif
>> +
>> static inline int get_core_count(void)
>> {
>> 	/* 1 + the PART[1:0] field of MIDR */
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

