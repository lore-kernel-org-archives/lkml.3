Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaE3Uh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:37:58 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40355 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaE3Uh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:37:56 -0400
Date: Fri, 30 May 2014 14:37:41 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
Message-ID: <20140530203741.GA30134@obsidianresearch.com>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
 <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
 <47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org>
 <20140530005602.GE1677@bart.dudau.co.uk>
 <CAErSpo7qEhJyUAu58R8g6+AEhRGo_+Vv0EMgkK+3ZQOU9+jmhg@mail.gmail.com>
 <20140530014116.GF1677@bart.dudau.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530014116.GF1677@bart.dudau.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 02:41:17AM +0100, Liviu Dudau wrote:

> Agree, I'm only concerned that if this ECAM config space gets added to
> the list of pci_host_bridge windows it will be indistinguishable from
> IORESOURCE_MEM resources and pci_create_root_bus() will add it to the
> bus and allow devices present on that bus to be assigned addresses from
> that range. Which might not be what one wants for certain BARs.

I wouldn't worry about supporting config in ranges. ECAM is the
logical use for config ranges, but it isn't specified and probably
will never be.

Will's driver the is the only driver I've seen to support ECAM and it
didn't use ranges.

Jason
