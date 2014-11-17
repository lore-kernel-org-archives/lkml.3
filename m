Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaKQKJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:09:10 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53682 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaKQKJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:09:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Suravee.Suthikulpanit@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wuyun <wuyun.wu@huawei.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 01/16] PCI: Enhance pci_scan_root_bus() to support default IO/MEM resources
Date: Mon, 17 Nov 2014 11:08:34 +0100
Message-ID: <2732970.7HG94QvVBv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416219710-26088-2-git-send-email-wangyijing@huawei.com>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1416219710-26088-2-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MBa1DRmSOBDs6R26wfJJ1i8gvO0vJQdTc2tGi696nyZ
 CkSVXeWK4ySnY94TSlBEPYfWBQSFYYQYPcPKYCl1qQLH89trd5
 QjQNPaQIgXDYbS4CbrWaqAZ7Y8+dSkzVr78tA7WFlMKioGfbih
 QTiUiMUtQ5Ivwd5KmkknVxcQomzuZ1Q6Wqpbk23ZPIBOmAV5Z7
 VTHF5DjpIhjHTCuu63jQTIvSkq4DAU1at77GCZUAcEM3KYV6wN
 A6wmv2T8RP28vrR4arpJqRxQVGi+FITKZyeThWZMlGXabDSgDe
 pjsz5InT+9EQPyLP9mIiU2DHNUdPtFgXwW79AWljE1Y79IDbbD
 pGPO7Wq9xcD+xBZiEizY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 18:21:35 Yijing Wang wrote:
> -       list_for_each_entry(window, resources, list)
> -               if (window->res->flags & IORESOURCE_BUS) {
> -                       found = true;
> -                       break;
> -               }
> +       if (!resources) {
> +               pci_add_resource(&default_res, &ioport_resource);
> +               pci_add_resource(&default_res, &iomem_resource);
> +               pci_add_resource(&default_res, &busn_resource);
> +       } else {
> 

Isn't it almost always wrong to do this? You are adding all of the
I/O ports and memory to the host bridge, which will prevent you from
adding another host bridge, and the iomem_resource normally
includes a lot of addresses that are not accessible by the PCI host.

	Arnd
