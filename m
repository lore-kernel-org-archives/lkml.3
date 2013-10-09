Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3JIJGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:06:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37253 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab3JIJGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:06:10 -0400
Message-ID: <52551C6E.1040404@ti.com>
Date: Wed, 9 Oct 2013 14:35:50 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Bjorn Helgaas'" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] PCI: designware: Add irq_create_mapping()
References: <000401cec4c6$dc415180$94c3f480$%han@samsung.com>
In-Reply-To: <000401cec4c6$dc415180$94c3f480$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Wednesday 09 October 2013 01:39 PM, Jingoo Han wrote:
> Without irq_create_mapping(), the correct irq number cannot be
> provided. In this case, it makes problem such as NULL deference.
> Thus, irq_create_mapping() should be added for MSI.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Tested on Exynos5440.
> 
>  drivers/pci/host/pcie-designware.c |   10 ++++------
>  drivers/pci/host/pcie-designware.h |    1 +
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 8963017..e536bb6 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -237,6 +237,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
>  		}
>  	}
>  
> +	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
> +

I think irq_create_mapping should be done for all the MSI irq lines instead of
only the first line. So you might have to do for MAX_MSI_IRQS lines.

Thanks
Kishon
