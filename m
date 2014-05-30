Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365AbaE3Uo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:44:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57661 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaE3UoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:44:25 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140530203741.GA30134@obsidianresearch.com>
Date: Fri, 30 May 2014 15:44:18 -0500
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robherring2@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <69822442-4373-4CDA-916D-77450AADF6A3@codeaurora.org>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org> <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com> <47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org> <20140530005602.GE1677@bart.dudau.co.uk> <CAErSpo7qEhJyUAu58R8g6+AEhRGo_+Vv0EMgkK+3ZQOU9+jmhg@mail.gmail.com> <20140530014116.GF1677@bart.dudau.co.uk> <20140530203741.GA30134@obsidianresearch.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 30, 2014, at 3:37 PM, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Fri, May 30, 2014 at 02:41:17AM +0100, Liviu Dudau wrote:
> 
>> Agree, I'm only concerned that if this ECAM config space gets added to
>> the list of pci_host_bridge windows it will be indistinguishable from
>> IORESOURCE_MEM resources and pci_create_root_bus() will add it to the
>> bus and allow devices present on that bus to be assigned addresses from
>> that range. Which might not be what one wants for certain BARs.
> 
> I wouldn't worry about supporting config in ranges. ECAM is the
> logical use for config ranges, but it isn't specified and probably
> will never be.
> 
> Will's driver the is the only driver I've seen to support ECAM and it
> didn't use ranges.

I expect with 64-bit parts we will see more use of ECAM, I think the reason its not used much is because of the address space it chews up, but that becomes less of an issue with LPAE or 64-bit parts with larger physical address spaces.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

