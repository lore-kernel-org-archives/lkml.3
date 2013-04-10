Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936034Ab3DJNMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:12:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46827 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3DJNMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:12:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="37200069"
Message-ID: <51656524.10708@codeaurora.org>
Date: Wed, 10 Apr 2013 09:12:04 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: Fix task tracing
References: <20130408153132.GQ17476@mudshark.cambridge.arm.com> <1365510814-21343-1-git-send-email-cov@codeaurora.org> <20130410114126.GB26992@mudshark.cambridge.arm.com>
In-Reply-To: <20130410114126.GB26992@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 04/10/2013 07:41 AM, Will Deacon wrote:
> On Tue, Apr 09, 2013 at 01:33:34PM +0100, Christopher Covington wrote:
>> For accurate accounting pass contextidr_thread_switch the prev
>> task pointer, since cpu_switch_to has at that point changed the
>> the stack pointer.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> 
> Thanks Christopher -- I assume that using prev did resolve your issues?

Yes indeed. We're now able to see in simulation that if a userspace process
uses 100% CPU, its thread ID, rather than what was usually some random
kthread, gets written out most of the time. I donno if that meets your
criteria for a "real" use case, but I hope it's at least sufficient testing of
the code for now.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
