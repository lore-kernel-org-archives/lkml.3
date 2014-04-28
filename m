Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaD1ApA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:45:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:45965 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaD1Ao6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:44:58 -0400
Message-ID: <1398645801.8437.84.camel@pasglop>
Subject: Re: [PATCH 08/13] PCI, rpaphp: Use new pci_is_bridge() to simplify
 code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Date: Mon, 28 Apr 2014 10:43:21 +1000
In-Reply-To: <1398417515-8740-9-git-send-email-wangyijing@huawei.com>
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
	 <1398417515-8740-9-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 17:18 +0800, Yijing Wang wrote:
> Now we can use new pci_is_bridge() helper function
> to simplify code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  drivers/pci/hotplug/rpadlpar_core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/rpadlpar_core.c b/drivers/pci/hotplug/rpadlpar_core.c
> index 4fcdeed..7660232 100644
> --- a/drivers/pci/hotplug/rpadlpar_core.c
> +++ b/drivers/pci/hotplug/rpadlpar_core.c
> @@ -157,8 +157,7 @@ static void dlpar_pci_add_bus(struct device_node *dn)
>  	}
>  
>  	/* Scan below the new bridge */
> -	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> -	    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
> +	if (pci_is_bridge(dev))
>  		of_scan_pci_bridge(dev);
>  
>  	/* Map IO space for child bus, which may or may not succeed */


