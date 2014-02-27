Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaB0TOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:14:16 -0500
Received: from dliviu.plus.com ([80.229.23.120]:60541 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaB0TOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:14:14 -0500
Date: Thu, 27 Feb 2014 19:12:59 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140227191259.GA31753@bart.dudau.co.uk>
Mail-Followup-To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
 <20140227181951.GC24656@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140227181951.GC24656@obsidianresearch.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Feb 27 19:14:12 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 530f8e843197119664735
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:19:51AM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 27, 2014 at 01:06:39PM +0000, Liviu Dudau wrote:
> > +	if (res->flags & IORESOURCE_IO) {
> > +		unsigned long port;
> > +		port = pci_address_to_pio(range->pci_addr);
> 
> This looks very suspicious, pci_addr is not unique across all domains,
> so there is no way to convert from a pci_addr to the virtual IO
> address without knowing the domain number as well.
> 
> I would like to see it be:
>   port = pci_address_to_pio(range->cpu_addr);
> 
> cpu_addr is unique across all domains.

Jason,

First thanks for reviewing the updated series.

We have agreed early on that indeed using range->cpu_addr is the correct aproach
and me taking the lazy shortcut of using range->pci_addr because of the broken
default implementation of pci_address_to_pio is wrong. I will fix this for v3.

The outstanding issue is how to fix pci_address_to_pio() as it will not
for for range->cpu_addr > IO_SPACE_LIMIT (16MB in my case).

Best regards,
Liviu

> 
> Looking at the microblaze and PPC versions I think the above version
> is actually correct (assuming io_base_phys is the CPU address of the
> IO window)
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

