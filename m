Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3DYXZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:25:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20958 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3DYXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:25:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,553,1363158000"; 
   d="scan'208";a="41682422"
Message-ID: <5179BB80.9060405@codeaurora.org>
Date: Thu, 25 Apr 2013 16:25:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCHv2 1/4] Documentation: Add memory mapped ARM architected
 timer binding
References: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org> <1365812863-5367-2-git-send-email-sboyd@codeaurora.org> <516C6F12.5020208@gmail.com> <516C7231.6060305@codeaurora.org> <5179A488.5050102@gmail.com> <5179B2B2.8000201@codeaurora.org> <5179B6ED.9000301@gmail.com>
In-Reply-To: <5179B6ED.9000301@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/13 16:06, Rob Herring wrote:
> On 04/25/2013 05:48 PM, Stephen Boyd wrote:
>
>> We don't really care about CNTFRQ because it's duplicated into each
>> view. We do care about CNTNSAR. Luckily the spec "just works" there in
>> the sense that we can use CNTTIDR in conjunction with CNTACRn and
>> determine if we have access to a frame we're interested in if the
>> CNTTIDR bits say the frame is present and the CNTACRn register says we
>> can access it. If not then it must be locked down for secure users.
>>
>> Unfortunately hardware doesn't have a way to say that a particular frame
>> is reserved for the hypervisor or the guest kernel/userspace. We need
>> some help from software, so we have the status property express that a
>> particular frame is available. We have to assume the DT is going to be
>> different depending on if you're the hypervisor or the guest. That's a
>> valid assumption right? Otherwise I hope we can do some trapping of the
>> guest's mapping to the control base and then rewrite what they read so
>> that they only see the frame that we want to be available to them.
> Yeah, I believe the only way to prevent access within non-secure world
> is with the MMU. So I guess the example is just policy that the
> hypervisor would/may not create a stage2 mapping. You still have the
> same issue that the guest should not be passed the control base. You
> could make the reg property optional, but then what do you do with the
> node name?

I don't follow. Why shouldn't we tell the guest about the hardware
that's there? Shouldn't they be able to safely assume they can access
the control base just like a non-guest kernel running in PL1 would be
able to?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

