Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaK0CAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:00:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:48138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaK0CAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:00:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,466,1413270000"; 
   d="scan'208";a="614711873"
Message-ID: <547685BB.3020109@linux.intel.com>
Date: Thu, 27 Nov 2014 10:00:27 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
CC: peter.chen@freescale.com, sojka@merica.cz, mathias.nyman@intel.com,
        balbi@ti.com, gregkh@linuxfoundation.org, tony@atomide.com,
        bcousson@baylibre.com, kgene.kim@samsung.com, ben-linux@fluff.org,
        linux@arm.linux.org.uk, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Subject: Re: [PATCH 06/19] usb: dwc3: host: Pass the XHCI_DRD_SUPPORT and
 XHCI_NEEDS_LHC_RESET quirk
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com> <1416921115-10467-7-git-send-email-george.cherian@ti.com>
In-Reply-To: <1416921115-10467-7-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月25日 21:11, George Cherian wrote:
> Pass the quir flag XHCI_DRD_SUPPORT from DWC3 host to xhci platform driver.
"quir" to "quirk"

Regards,
Baolu

> This enables xhci driver to handle deallocation's differently while in DRD mode.
> Pass the quirk flag XHCI_NEEDS_LHC_RESET from DWC3 host to xhci platform
> driver. This enables to do LHRESET during xhci_reset().
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/dwc3/host.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> index dcb8ca0..257b5b5 100644
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -53,6 +53,8 @@ int dwc3_host_init(struct dwc3 *dwc)
>   #ifdef CONFIG_DWC3_HOST_USB3_LPM_ENABLE
>   	pdata.usb3_lpm_capable = 1;
>   #endif
> +	pdata.usb_drd_support = 1;
> +	pdata.usb_needs_lhc_reset = 1;
>   
>   	ret = platform_device_add_data(xhci, &pdata, sizeof(pdata));
>   	if (ret) {

