Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3KER1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:27:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59641 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3KER1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:27:19 -0500
Message-ID: <52792A75.6060306@codeaurora.org>
Date: Tue, 05 Nov 2013 09:27:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH 05/11] ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu
 hotplug/smp
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-6-git-send-email-sboyd@codeaurora.org> <E3155290-B7BD-4559-BB0E-6C6C7D74ACFB@codeaurora.org>
In-Reply-To: <E3155290-B7BD-4559-BB0E-6C6C7D74ACFB@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 09:24, Kumar Gala wrote:
> On Nov 1, 2013, at 5:08 PM, Stephen Boyd wrote:
>
>> @@ -150,8 +182,14 @@ void __init arm_dt_init_cpu_maps(void)
>> 		}
>>
>> 		tmp_map[i] = hwid;
>> +
>> +		if (!found_method)
>> +			found_method = set_smp_ops_by_method(cpu);
>> 	}
>>
>> +	if (!found_method)
>> +		set_smp_ops_by_method(cpus);
>> +
> I assume this if for the case that the enable method is in the cpus{ } container but not in a specific cpu node?
>
> If so, the binding is not clear that we allow this.  Also a comment would probably be nice.

Sure I'll add a comment to that effect and clarify the binding.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

