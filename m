Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3HGSud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:50:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49076 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3HGSu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:50:26 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-e7-520296ef23f3
Message-id: <520296ED.7080003@samsung.com>
Date: Wed, 07 Aug 2013 20:50:21 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Julius Werner <jwerner@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
 <20130807163045.GK28558@e106331-lin.cambridge.arm.com>
 <CAODwPW9DmVdzHbHN0NUK0fYUNw0tj2ktyh-20no30r14_JayFQ@mail.gmail.com>
In-reply-to: <CAODwPW9DmVdzHbHN0NUK0fYUNw0tj2ktyh-20no30r14_JayFQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xa7rvpzEFGexdwGVx8H69xfwj51gt
	2q4cZLd409vBYtFx6DGTRe+Cq2wWl3fNYbOYcX4fk8WiZa3MFkuvX2SymDB9LYvF4RUHmCxe
	HWxjsZj3eSeTxfoZr1kc+D3WzFvD6LHg8xV2j9kNF1k8Xk+ewOixc9Zddo++LasYPY7f2M7k
	8XmTnMfGuaEBnFFcNimpOZllqUX6dglcGcePP2cvWCNY0bHevIHxFW8XIyeHhICJROuTHSwQ
	tpjEhXvr2UBsIYGljBLzv6h2MXIB2Z8YJeY0dDKCJHgFtCQ+L7nCDmKzCKhKTDvawQxiswkY
	SvQe7QOrERUIkFi85Bw7RL2gxI/J94AWcHCICGhIXLvnDzKTWWAOq0RX90cmkLgwUP2XJbkQ
	ew8zStyaLwZicwoES+x/sABsDLOAjsT+1mlsELa8xOY1b5knMArMQrJhFpKyWUjKFjAyr2IU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQIiaovOxgXH7M6xCjAwajEw9sRwBQkxJpYVlyZe4hR
	goNZSYT3YjFQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+MEl+x+odLgVeWr644cUmXKCpbmt+cq
	tG/ri7M+azRlvihPXkRW9em3GUVWjSY+us+uRuuo9Z+qXrDxwbSDnRkfKm+7vWt1z7rLfE/7
	ttPCYN+9CkcfLTxWmi3SyXJ/3QePRO/TmxLl9qmrTFxWfcbbOswsKHH7N7Em85VbJn+qlXjq
	IOH3RImlOCPRUIu5qDgRABLUkLmIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 07:06 PM, Julius Werner wrote:
>> This breaks compatibility, both for an old kernel and a new dt and a new
>> kernel with an old dt. Is anyone using these bindings?
> 
> They only affect Samsung SoCs and have only been upstream for half a
> year, so I doubt it's heavily used.

It probably wouldn't be of much concern, but I can't tell for sure.

>> Why are we describing fewer registers now? Are they described elsewhere?
>>
>> The dt should describe the device, not only the portion of it Linux
>> wants to use right now.
> 
> This only ever described a small section of the huge set of PMU
> registers anyway. 

The PMU registers are already scattered across various drivers, like
Power Domain, various PHYs (USB/HSIC/MIPI CSI-2/DSI, ADC, ...), Reset
and more. And it happens currently there is no central driver for
the Power Management Unit, that would, for example expose the regmap
interface that the interested drivers could use. The downside of this
would be that each, e.g. USB PHY driver would need to know SoC specific
offsets to its registers in the PMU.

Before device tree started to be used those PMU registers were controlled
by respective drivers, mostly through platform_data callbacks. As they
could be considered parts of given device.

                   Before it described up to three registers
> controlling different PHYs (using hardcoded offsets in the code to
> later find the right one)... with my patch every PHY's DT entry only
> describes the one register concerning itself, which makes more sense
> in my opinion. It will also prevent the register descriptions in
> different DT entries from overlapping.

Yes, the patch looks sensible. Since currently each USB PHY has its
own device tree node it looks wrong to have the reg property in the
usbphy-sys subnodes defining register region for all possible PHYs.
And we indeed and up with multiple reg properties pointing to same
register region.

However the biggest drawback is breaking backwards compatibility.
I'm not sure if those changes are worth it, especially that all those
USB PHY drivers are supposed to be rewritten to use the generic PHY API.


Thanks,
Sylwester
