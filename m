Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3GKOd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:33:59 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63452 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933222Ab3GKOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:33:56 -0400
Message-ID: <1373553233.1349.15.camel@x61.thuisdomein>
Subject: Re: [PATCH -v2 3/3] PCI,pciehp: use PCIe DSN to identify device
 change during suspend
From: Paul Bolle <pebolle@tiscali.nl>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Thu, 11 Jul 2013 16:33:53 +0200
In-Reply-To: <1373535825-49972-4-git-send-email-wangyijing@huawei.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
	 <1373535825-49972-4-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 14:33:54.0096 (UTC) FILETIME=[AB3A5B00:01CE7E43]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 17:43 +0800, Yijing Wang wrote:
[...]
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 1542735..f2eb214 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
[...]
> @@ -315,6 +342,24 @@ static int pciehp_resume (struct pcie_device *dev)
>  	if (status) {
>  		if (list_empty(&pbus->devices))
>  			pciehp_enable_slot(slot);
> +
> +		if (device_serial_number_changed(pbus)) {
> +			/*
> +			 * first power off slot, avoid the old driver
> +			 * .remove() method touch the new hardware
> +			 */
> +			if (POWER_CTRL(ctrl)) {
> +				retval = pciehp_power_off_slot(slot);
> +				if (retval) {
> +					ctrl_err(ctrl,
> +						"Issue of Slot Disable command failed\n");
> +					return 0;
> +				}
> +				msleep(1000);
> +				pciehp_unconfigure_device(slot);
> +				pciehp_enable_slot(slot);
> +			}
> +		}
>  	} else if (!list_empty(&pbus->devices))
>  		pciehp_disable_slot(slot);
>  	

It was surprisingly hard to see why the patch wouldn't apply to v3.10.
It turns out the very last line of context is a line consisting of just
a single tab. And in v3.10 it is an empty line. 

Is that lone tab perhaps an editing mistake on your side?


Paul Bolle

