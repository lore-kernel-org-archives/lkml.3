Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaE2PRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:17:21 -0400
Received: from dliviu.plus.com ([80.229.23.120]:36707 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbaE2PRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:17:19 -0400
From: "Liviu Dudau" <liviu@dudau.co.uk>
Date: Thu, 29 May 2014 16:18:40 +0100
To: Kumar Gala <galak@codeaurora.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        arnd@arndb.de, tony@atomide.com, Mohit Kumar <mohit.kumar@st.com>,
        jg1.han@samsung.com, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should be
 specified in 'reg'
Message-ID: <20140529151840.GD1677@bart.dudau.co.uk>
Mail-Followup-To: Kumar Gala <galak@codeaurora.org>,
	Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
	arnd@arndb.de, tony@atomide.com, Mohit Kumar <mohit.kumar@st.com>,
	jg1.han@samsung.com,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Bjorn Helgaas <bhelgaas@google.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
 <1401345500-20188-4-git-send-email-kishon@ti.com>
 <98E18225-3C63-4106-901A-A5D3DEC268C8@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <98E18225-3C63-4106-901A-A5D3DEC268C8@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu May 29 16:17:17 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53874f7d3035858913175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:03:54AM -0500, Kumar Gala wrote:
> 
> On May 29, 2014, at 1:38 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> 
> > The configuration address space has so far been specified in *ranges*,
> > however it should be specified in *reg* making it a platform MEM resource.
> > Hence used 'platform_get_resource_*' API to get configuration address
> > space in the designware driver.
> > 
> > Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Mohit Kumar <mohit.kumar@st.com>
> > Cc: Jingoo Han <jg1.han@samsung.com>
> > Cc: Marek Vasut <marex@denx.de>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> > .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
> > drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
> > 2 files changed, 16 insertions(+), 2 deletions(-)
> 
> Why should the cfg space be defined in *reg* instead of ranges?

Because what you end up using is a struct resource to represent the cfg space and
the conversion between ranges and resources breaks down for CFG space (we don't
have a flag in the resource flags to say this is CFG resource). Specifying it
as a *reg* property makes it a MEM resource and no special casing is needed.

Best regards,
Liviu

> 
> - k
> 
> -- 
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

