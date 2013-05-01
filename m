Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399Ab3EAOoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:44:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58401 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3EAOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:44:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,589,1363158000"; 
   d="scan'208";a="43286102"
Message-ID: <51812A4F.7060400@codeaurora.org>
Date: Wed, 01 May 2013 10:44:31 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/4] arm64: Move to generic sched_clock infrastructure
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org> <1367369675-13535-1-git-send-email-sboyd@codeaurora.org> <1367369675-13535-2-git-send-email-sboyd@codeaurora.org> <20130501091108.GB10984@arm.com>
In-Reply-To: <20130501091108.GB10984@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 05:11 AM, Catalin Marinas wrote:
> On Wed, May 01, 2013 at 01:54:35AM +0100, Stephen Boyd wrote:
>> Use the generic sched_clock infrastructure instead of rolling our
>> own. This has the added benefit of fixing suspend/resume as
>> outlined in 6a4dae5 (ARM: 7565/1: sched: stop sched_clock()
>> during suspend, 2012-10-23) and correcting the timestamps when
>> the hardware returns a value instead of 0 upon the first read.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Looks ok.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I built and ran this change and dependencies on top of Catalin's
soc-armv8-model branch [1] and was able to verify that it fixed the printk
timestamp jump.

1.
http://git.kernel.org/cgit/linux/kernel/git/cmarinas/linux-aarch64.git/log/?h=soc-armv8-model

Tested-by: Christopher Covington <cov@codeaurora.org>

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
