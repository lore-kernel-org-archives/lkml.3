Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaE2Uvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:51:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41793 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaE2Uve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:51:34 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
Date: Thu, 29 May 2014 15:51:28 -0500
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
Content-Transfer-Encoding: 8BIT
Message-Id: <47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org> <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29, 2014, at 3:44 PM, Rob Herring <robherring2@gmail.com> wrote:

> On Thu, May 29, 2014 at 11:03 AM, Kumar Gala <galak@codeaurora.org> wrote:
>> If we have a PCI config space specified in something like a ranges
>> property we should treat it as memory type resource.
> 
> Config space should not be in ranges[1]. We have some cases that are,
> but we don't want new ones.

For the cases we have I agree, however an ECAM based cfg seems completely legit.

>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> drivers/of/address.c | 3 +++
>> 1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/of/address.c b/drivers/of/address.c
>> index cb4242a..4e7ee59 100644
>> --- a/drivers/of/address.c
>> +++ b/drivers/of/address.c
>> @@ -122,6 +122,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
>>        u32 w = be32_to_cpup(addr);
>> 
>>        switch((w >> 24) & 0x03) {
>> +       case 0x00: /* cfg space */
>> +               flags |= IORESOURCE_MEM;
>> +               break;
> 
> How would you then distinguish actual memory ranges?

One assumes you are still looking at pci_space as part of of_pci_range

> 
> Rob
> 
> [1] http://www.spinics.net/lists/linux-pci/msg30585.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

