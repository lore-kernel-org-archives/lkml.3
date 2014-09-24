Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaIXRNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:13:07 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36856 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:13:05 -0400
Date: Wed, 24 Sep 2014 18:12:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sunil Goutham <sgoutham@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH 6/6] pci, thunder: Enable Cavium Thunder PCIe host
 controller
Message-ID: <20140924171249.GP15842@e104818-lin.cambridge.arm.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <1411573068-12952-7-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411573068-12952-7-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 04:37:48PM +0100, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> Enable Cavium Thunder PCIe host controller driver.
> 
> IOV is enabled per default if drivers with IOV support are
> enabled. IOV can be disabled.
> 
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  arch/arm64/Kconfig | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 97777e1ef5a7..bd9724e5c8a1 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -172,6 +172,14 @@ config PCI
>  config PCI_MSI
>  	def_bool PCI
>  
> +config NO_PCI_IOV
> +	def_bool PCI
> +	depends on !PCI_THUNDER
> +
> +config PCI_IOV
> +	def_bool PCI
> +	depends on !NO_PCI_IOV

Does this work with single image where drivers may have different
PCI_IOV needs?

-- 
Catalin
