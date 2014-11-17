Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaKQMxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:53:24 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45007 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaKQMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:53:22 -0500
Message-ID: <5469EFBB.6000806@linaro.org>
Date: Mon, 17 Nov 2014 13:53:15 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>, "nsekhar@ti.com" <nsekhar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "tony@atomide.com" <tony@atomide.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: Invert CPUIDLE_FLAG_TIME_VALID logic
References: <1415804630-5055-1-git-send-email-daniel.lezcano@linaro.org> <20141113145609.GA9726@red-moon>
In-Reply-To: <20141113145609.GA9726@red-moon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 03:56 PM, Lorenzo Pieralisi wrote:
> On Wed, Nov 12, 2014 at 03:03:50PM +0000, Daniel Lezcano wrote:
>> The only place where the time is invalid is when the ACPI_CSTATE_FFH entry
>> method is not set. Otherwise for all the drivers, the time can be correctly
>> measured.
>>
>> Instead of duplicating the CPUIDLE_FLAG_TIME_VALID flag in all the drivers
>> for all the states, just invert the logic by replacing it by the flag
>> CPUIDLE_FLAG_TIME_INVALID, hence we can set this flag only for the acpi idle
>> driver, remove the former flag from all the drivers and invert the logic with
>> this flag in the different governor.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> Are we sure that ACPI C1 invalid residency time is *still* an issue after
> we moved the residency accounting to the idle core ?

(Cc'ed linux-acpi@)

Hi x86 guys,

any comment on that ?

Thanks in advance

  -- Daniel

> I have a feeling you can remove this flag entirely, but I will let x86
> guys speak for themselves.

[ ... ]

>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index 17f9ec5..380b4b4 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -985,8 +985,8 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
>>                  state->flags = 0;
>>                  switch (cx->type) {
>>                          case ACPI_STATE_C1:
>> -                       if (cx->entry_method == ACPI_CSTATE_FFH)
>> -                               state->flags |= CPUIDLE_FLAG_TIME_VALID;
>> +                       if (cx->entry_method != ACPI_CSTATE_FFH)
>> +                               state->flags |= CPUIDLE_FLAG_TIME_INVALID;

[ ... ]


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

