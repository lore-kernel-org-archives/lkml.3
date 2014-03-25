Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaCYI5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:57:43 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:14078 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753303AbaCYI5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:57:38 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 04:57:37 EDT
X-IronPort-AV: E=Sophos;i="4.97,726,1389711600"; 
   d="scan'208";a="156214112"
In-Reply-To: <1395270762-6055-2-git-send-email-tinamdar@apm.com>
References: <1395270762-6055-1-git-send-email-tinamdar@apm.com> <1395270762-6055-2-git-send-email-tinamdar@apm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, jcm@redhat.com,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pci-owner@vger.kernel.org, Liviu Dudau <liviu.dudau@arm.com>,
        patches@apm.com, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>
MIME-Version: 1.0
X-KeepSent: 8E4162E1:91105680-80257CA6:002FEBD9;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Phil.Edworthy@renesas.com
Message-ID: <OF8E4162E1.91105680-ON80257CA6.002FEBD9-80257CA6.0030BE31@eu.necel.com>
Date: Tue, 25 Mar 2014 08:52:24 +0000
Subject: Re: [PATCH v5 1/4] pci: APM X-Gene PCIe controller driver
X-MIMETrack: Serialize by Router on DU0NOTES13/SERVER/REE(Release 8.5.3 HF466|March 09, 2012) at
 25.03.2014 09:52:32,
	Serialize complete at 25.03.2014 09:52:32
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tanmay,

On: 19/03/2014 23:15, Tanmay wrote:
> Subject: [PATCH v5 1/4] pci: APM X-Gene PCIe controller driver
> Sent by: linux-pci-owner@vger.kernel.org
> 
> This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
> X-Gene PCIe controller supports maximum up to 8 lanes and GEN3 speed.
> X-Gene SOC supports maximum 5 PCIe ports.
<snip>

> +static void xgene_pcie_setup_ib_reg(struct xgene_pcie_port *port,
> +                struct of_pci_range *range, u8 *ib_reg_mask)
> +{
> +   void __iomem *csr_base = port->csr_base;
> +   void __iomem *cfg_base = port->cfg_base;
> +   void *bar_addr;
> +   void *pim_addr;
> +   u64 restype = range->flags & IORESOURCE_TYPE_BITS;
> +   u64 cpu_addr = range->cpu_addr;
> +   u64 pci_addr = range->pci_addr;
> +   u64 size = range->size;
> +   u64 mask = ~(size - 1) | EN_REG;
> +   u32 flags = PCI_BASE_ADDRESS_MEM_TYPE_64;
> +   u32 bar_low;
> +   int region;
> +
> +   region = xgene_pcie_select_ib_reg(ib_reg_mask, range->size);
> +   if (region < 0) {
> +      dev_warn(port->dev, "invalid pcie dma-range config\n");
> +      return;
> +   }
> +
> +   if (restype == PCI_BASE_ADDRESS_MEM_PREFETCH)
> +      flags |= PCI_BASE_ADDRESS_MEM_PREFETCH;

Since IORESOURCE_TYPE_BITS is 0x00001f00, and 
PCI_BASE_ADDRESS_MEM_PREFETCH is 0x08, this will never match. I think you 
are mixing up different sets of definitions here. Also, the address 
properties in range->flags are bitfields.

Regards
Phil
