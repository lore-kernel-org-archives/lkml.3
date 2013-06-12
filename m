Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3FLQzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:55:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41697 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3FLQy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:54:59 -0400
Message-ID: <51B8A7E1.1020708@codeaurora.org>
Date: Wed, 12 Jun 2013 09:54:57 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 12/12] ARM: msm: Migrate to common clock framework
References: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org> <1370373938-32417-13-git-send-email-sboyd@codeaurora.org> <20130611222832.8816.77120@quantum>
In-Reply-To: <20130611222832.8816.77120@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 15:28, Mike Turquette wrote:
> Quoting Stephen Boyd (2013-06-04 12:25:38)
>> Move the existing clock code in mach-msm to the common clock
>> framework. We lose our capability to set the rate of and enable a
>> clock through debugfs. This is ok though because the debugfs
>> features are mainly used for testing and development of new clock
>> code.
>>
>> To maintain compatibility with the original MSM clock code we
>> make a wrapper for clk_reset() that calls the struct msm_clk
>> specific reset function. This is necessary for the usb and sdcc
>> devices on MSM until a better suited API is made available.
>>
>> Cc: Saravana Kannan <skannan@codeaurora.org>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> I just went through this quickly and nothing popped out at me.  Nice
> diffstat btw!  Do you have any plans to move this to drivers/clk/msm ?
>
> Acked-by: Mike Turquette <mturquette@linaro.org>

Thanks Mike.

I plan to add mmio support under drivers/clk/msm. Moving this proc_comm
based code to drivers/clk/msm is possible but it would need to depend on
the 3 architectures that use it so that it isn't available or compiled
on our DT based platforms. We can do that later I suppose.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

