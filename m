Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3CESpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:45:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2449 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3CESpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:45:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355126400"; 
   d="scan'208";a="27558230"
Message-ID: <51363D37.1090107@codeaurora.org>
Date: Tue, 05 Mar 2013 10:45:11 -0800
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
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org> <1361518039-16663-9-git-send-email-sboyd@codeaurora.org> <20130222111545.GA15020@e106331-lin.cambridge.arm.com> <20130222162458.GA19670@linux-sh.org> <20130225134041.GA22785@e106331-lin.cambridge.arm.com> <5135333E.6030305@codeaurora.org> <20130305110239.GC15661@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130305110239.GC15661@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 03:02, Mark Rutland wrote:
>
>>> +
>>> +static void dummy_set_mode(enum clock_event_mode mode,
>>> +			   struct clock_event_device *evt)
>>> +{
>>> +	/*
>>> +	 * Core clockevents code will call this when exchanging timer devices.
>>> +	 * We don't need to do anything here.
>>> +	 */
>>> +}
>>> +
>>> +static void __cpuinit dummy_setup(void)
>>> +{
>>> +	int cpu = smp_processor_id();
>>> +	struct clock_event_device *evt = &per_cpu(dummy_evt, cpu);
>> Can we use __this_cpu_ptr()? I wonder if that makes the code generation
>> better or worse. I didn't do it in my 8/8 patch because I wanted the
>> code to be the same before and after to show code movement.
> I did that originally, but thought as I needed the cpu value for the mask
> anyway that there wasn't much point. I'm not that good at reading generated
> assembly, so I can't really say if either's better.

It looks to be two instructions shorter.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

