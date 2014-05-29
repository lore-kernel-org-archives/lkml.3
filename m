Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaE2Vu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:50:29 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47330 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaE2VuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
	<CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
	<47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org>
Date: Thu, 29 May 2014 16:50:24 -0500
Message-ID: <CAL_JsqK8PJHUgb0-i=6MdydAo-97iUTBfnqVgTchgghY8R9XZA@mail.gmail.com>
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
From: Rob Herring <robherring2@gmail.com>
To: Kumar Gala <galak@codeaurora.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <liviu@dudau.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Jason Gunthorpe...

On Thu, May 29, 2014 at 3:51 PM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On May 29, 2014, at 3:44 PM, Rob Herring <robherring2@gmail.com> wrote:
>
>> On Thu, May 29, 2014 at 11:03 AM, Kumar Gala <galak@codeaurora.org> wrote:
>>> If we have a PCI config space specified in something like a ranges
>>> property we should treat it as memory type resource.
>>
>> Config space should not be in ranges[1]. We have some cases that are,
>> but we don't want new ones.
>
> For the cases we have I agree, however an ECAM based cfg seems completely legit.

The previous discussion concluded otherwise. Debate it with Jason. I
don't really have an opinion other than it be done one way.

Rob

>>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>>> ---
>>> drivers/of/address.c | 3 +++
>>> 1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/of/address.c b/drivers/of/address.c
>>> index cb4242a..4e7ee59 100644
>>> --- a/drivers/of/address.c
>>> +++ b/drivers/of/address.c
>>> @@ -122,6 +122,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
>>>        u32 w = be32_to_cpup(addr);
>>>
>>>        switch((w >> 24) & 0x03) {
>>> +       case 0x00: /* cfg space */
>>> +               flags |= IORESOURCE_MEM;
>>> +               break;
>>
>> How would you then distinguish actual memory ranges?
>
> One assumes you are still looking at pci_space as part of of_pci_range
>
>>
>> Rob
>>
>> [1] http://www.spinics.net/lists/linux-pci/msg30585.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
>
