Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbbAWXST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:18:19 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37836 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbbAWXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:18:18 -0500
Date: Fri, 23 Jan 2015 17:18:14 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, donald.d.dugger@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Wellsburg (X99) to Intel PCH root port ACS quirk
Message-ID: <20150123231814.GT29776@google.com>
References: <20150122181524.1586.14496.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122181524.1586.14496.stgit@gimli.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:15:43AM -0700, Alex Williamson wrote:
> Intel has confirmed that the Wellsburg chipset, while not reporting
> ACS, does provide the proper isolation through the RCBA/BSPR
> registers, so the same quirk works for this set of device IDs.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Don Dugger <donald.d.dugger@intel.com>

Applied with Don's ack to pci/virtualization for v3.20, thanks!

> ---
> 
>  drivers/pci/quirks.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index ed6f89b..2cdb789 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3630,6 +3630,9 @@ static const u16 pci_quirk_intel_pch_acs_ids[] = {
>  	0x9c98, 0x9c99, 0x9c9a, 0x9c9b,
>  	/* Patsburg (X79) PCH */
>  	0x1d10, 0x1d12, 0x1d14, 0x1d16, 0x1d18, 0x1d1a, 0x1d1c, 0x1d1e,
> +	/* Wellsburg (X99) PCH */
> +	0x8d10, 0x8d11, 0x8d12, 0x8d13, 0x8d14, 0x8d15, 0x8d16, 0x8d17,
> +	0x8d18, 0x8d19, 0x8d1a, 0x8d1b, 0x8d1c, 0x8d1d, 0x8d1e,
>  };
>  
>  static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)
> 
