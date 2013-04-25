Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3DYSfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:35:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5078 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3DYSfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:35:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363158000"; 
   d="scan'208";a="41583431"
Message-ID: <51797760.4040906@codeaurora.org>
Date: Thu, 25 Apr 2013 11:35:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/4] Documentation: Add memory mapped ARM architected
 timer binding
References: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org> <1365812863-5367-2-git-send-email-sboyd@codeaurora.org> <516C6F12.5020208@gmail.com> <516C7231.6060305@codeaurora.org>
In-Reply-To: <516C7231.6060305@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

Can I get your ack on this binding or do you think we need to change
something?

Thanks,
Stephen

On 04/15/13 14:33, Stephen Boyd wrote:
> On 04/15/13 14:20, Rob Herring wrote:
>> On Fri, Apr 12, 2013 at 7:27 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> @@ -26,3 +30,52 @@ Example:
>>>                              <1 10 0xf08>;
>>>                 clock-frequency = <100000000>;
>>>         };
>>> +
>>> +** Memory mapped timer node properties
>>> +
>>> +- compatible : Should at least contain "arm,armv7-timer-mem".
>> Everything about this timer is architecturally defined? If not, let's
>> use a more specific name.
> I'm not sure I'm following you, but everything described here is part of
> the ARM definition. What would be a more specific name?
>
>>> +
>>> +- clock-frequency : The frequency of the main counter, in Hz. Optional.
>>> +
>>> +- reg : The control frame base address.
>>> +
>>> +Note that #address-cells, #size-cells, and ranges shall be present to ensure
>>> +the CPU can address a frame's registers.
>>> +
>>> +Frame:
>>> +
>>> +- frame-number: 0 to 7.
>> I'd really like to get rid of the frame numbers and sub-nodes. Is the
>> frame number significant to software?
> We need the frame number to read and write registers in the control
> frame (the first base in the parent node). We currently use it to
> determine if a frame has support for the virtual timer by reading the
> CNTTIDR (a register with 4 bits per frame describing capabilities). If
> we wanted to control access to the second view of a frame we would also
> need to configure the CNTPL0ACRn register that pertains to the frame
> we're controlling. Without a frame number we wouldn't know which
> register to write.
>
>>> +- interrupts : Interrupt list for physical and virtual timers in that order.
>>> +  The virtual timer interrupt is optional.
>> Is that optional per frame?
> Yes the virtual and physical timer interrupt is per-frame and the
> virtual interrupt is optional.
>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

