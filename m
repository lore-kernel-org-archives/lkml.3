Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbaAIUwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:52:33 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60997 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaAIUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:52:23 -0500
Message-ID: <52CF0C05.1080308@codeaurora.org>
Date: Thu, 09 Jan 2014 12:52:21 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] devicetree: bindings: Document Krait L1/L2 EDAC
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org> <1388434457-4194-5-git-send-email-sboyd@codeaurora.org> <20140107105439.GC5906@e102568-lin.cambridge.arm.com> <20140107201239.GD14405@codeaurora.org> <20140108100538.GA2927@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140108100538.GA2927@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 02:05, Lorenzo Pieralisi wrote:
> On Tue, Jan 07, 2014 at 08:12:39PM +0000, Stephen Boyd wrote:
>> On 01/07, Lorenzo Pieralisi wrote:
>>
>>> I have a problem with the cache level definition, and in
>>> particular the numbering, ie what the level number represents. If we
>>> mean the cache level seen through the CLIDR and co., it is hard to use
>>> it for shared caches since the level seen by different CPUs can actually
>>> be different, or put it differently the level number might not be unique for
>>> a shared cache. I need to think about a proper way to sort this out.
>>>
>> Ok. I don't even use this property in my driver. All I really
>> need is the phandle from cpus pointing to the L2 and the
>> interrupts property in the L2 node.
>>
>> How do you want to proceed here? If your cache binding goes
>> through I would just need to add the interrupts part. Or you
>> could even add that part in the same patch, you could have my
>> signed-off-by for that.
> Ok, I will try to update the bindings with the interrupt part and copy
> you in, even though the level definition worries me a bit, it is an
> important property for power management and I need to find a proper
> solution before bindings can get accepted (basically the problem is:
> if different CPUs can see a cache at different levels as defined in the
> CLIDR we cannot describe a cache with a single cache level or put it
> differently, level can not represent the value in the CLIDR hence we
> need to describe it differently).

Ok. I've dropped the cache part from this patch. I left the example as
is minus the cache-level attribute.

Understanding how the cache-level value would be used might help. I
wonder if the cache-level can just be a number that describes the
largest value that the cache could be assigned. Then if you have
different CPUs seeing different levels of cache they can traverse from
their CPU node to the cache and count how many phandles they went through.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

