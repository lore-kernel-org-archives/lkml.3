Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937140Ab3DIQml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:42:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22626 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936277Ab3DIQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:42:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="36925542"
Message-ID: <516444FE.2080200@codeaurora.org>
Date: Tue, 09 Apr 2013 09:42:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 1/4] Documentation: Add memory mapped ARM architected
 timer binding
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org> <1365474623-29181-2-git-send-email-sboyd@codeaurora.org> <20130409090843.GS23725@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130409090843.GS23725@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/13 02:08, Mark Rutland wrote:
> On Tue, Apr 09, 2013 at 03:30:20AM +0100, Stephen Boyd wrote:
>>  
>> -** Timer node properties:
>> +** CP15 Timer node properties:
>>  
>>  - compatible : Should at least contain one of
>>  	"arm,armv7-timer"
>> @@ -26,3 +30,55 @@ Example:
>>  			     <1 10 0xf08>;
>>  		clock-frequency = <100000000>;
>>  	};
>> +
>> +** Memory mapped timer node properties
>> +
>> +- compatible : Should at least contain "arm,armv7-timer-mem".
>> +
>> +- #address-cells : Must be 1.
> What about LPAE systems?
>
> How about something like the following:
>
> #address-cells : If the ranges property is empty, the same value as the
>                  parent node's #address-cells property. Otherwise, a
> 		 value such that the ranges property specifies a
> 		 mapping to the parent node's address space.            

Yes that is much better. I wasn't trying to preclude LPAE or 64 bit systems.

>> +
>> +- #size-cells : Must be 1.
>> +
>> +- ranges : Indicates parent and child bus address space are the same.
>> +
> Similarly, what if someone wants to write a more complex mapping for some
> reason?
>
> We should be able to handle it if we use the standard accessors.

Maybe I should just leave this part out? They are standard DT properties
so I could assume DT writers know what to do.

>> +- clock-frequency : The frequency of the main counter, in Hz. Optional.
>> +
>> +- reg : The control frame base address.
>> +
>> +Frame:
>> +
>> +- frame-id: Encoded as follows:
>> +		bits[3:0]  frame number: 0 to 7.
>> +		bits[10:8] frame usage:
>> +			0 - user/kernel
>> +			1 - hyp
>> +			2 - secure
>> +
> Could we not just have a disabled status property for those frames claimed by a
> higher level (either secure firmware or hypervisor)? Or have I missed something
> here?

Using disabled status would work. I was also thinking maybe we should
use a compatible string in each frame's node. Then we could match
against compatible children like "frame-user", "frame-kernel",
"frame-hyp", "frame-secure", "frame-user-kernel", etc. It allows us
flexibility if we should need to add something else in the future.

Also to get the frame number, I was thinking maybe we should expand the
reg property to have two address cells. Then we could have reg = <0
0xf0001000 0x1000>.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

