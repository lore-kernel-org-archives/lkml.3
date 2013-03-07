Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab3CGVlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:41:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64934 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626Ab3CGVlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:41:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,804,1355126400"; 
   d="scan'208";a="27871325"
Message-ID: <51390998.3090303@codeaurora.org>
Date: Thu, 07 Mar 2013 13:41:44 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 01/10] clocksource: add generic dummy timer driver
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-2-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.02.1303071457300.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303071457300.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/13 06:00, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Stephen Boyd wrote:
>
>> +static int __init dummy_timer_register(void)
>> +{
>> +	int err = register_cpu_notifier(&dummy_timer_cpu_nb);
>> +	if (err)
>> +		return err;
>> +
>> +	/* We won't get a call on the boot CPU, so register immediately */
>> +	dummy_timer_setup();
>> +
>> +	return 0;
>> +}
>> +device_initcall(dummy_timer_register);
> Are you sure that you want that to be installed unconditionally? What
> about multi-platform kernels?
>

A dummy timer is already installed unconditionally on devices with an
arm architected timer, so if this is breaking something then those
devices have been broken in the 3.9 merge window. I suppose we may need
to make the rating even lower if there is somebody using a clockevent
with a rating below 100. My grep of the tree shows 125 as the lowest,
but perhaps we want to set the rating to 1 to be safe?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

