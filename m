Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3CDXwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:52:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4132 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320Ab3CDXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:52:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,783,1355126400"; 
   d="scan'208";a="27660825"
Message-ID: <513533A4.3060300@codeaurora.org>
Date: Mon, 04 Mar 2013 15:52:04 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Paul Mundt <lethal@linux-sh.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] ARM: smp: Remove local timer API
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org> <1361518039-16663-9-git-send-email-sboyd@codeaurora.org> <20130222111545.GA15020@e106331-lin.cambridge.arm.com> <20130222162458.GA19670@linux-sh.org> <20130225134041.GA22785@e106331-lin.cambridge.arm.com> <5135333E.6030305@codeaurora.org>
In-Reply-To: <5135333E.6030305@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/13 15:50, Stephen Boyd wrote:
>
>> +
>> +	evt->name	= "dummy timer";
>> +	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
>> +			  CLOCK_EVT_FEAT_ONESHOT |
>> +			  CLOCK_EVT_FEAT_DUMMY;
>> +	evt->rating	= 100;
>> +	evt->set_mode	= dummy_set_mode;
>> +	evt->cpumask	= cpumask_of(cpu);
>> +
>> +	clockevents_register_device(evt);
>> +}
>> +
>> +static int __cpuinit dummy_cpu_notify(struct notifier_block *self,
>> +				      unsigned long action, void *hcpu)
>> +{
>> +	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
>> +		dummy_setup();
> There are already two dummy_setup() functions. Perhaps we can
> s/dummy/dummy_broadcast/ throughout this file?
>

Sorry, meant to say dummy_timer not dummy_broadcast.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

