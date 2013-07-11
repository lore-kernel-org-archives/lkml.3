Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3GKOTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:19:49 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51950 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631Ab3GKOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:19:47 -0400
Message-ID: <1373552385.1349.2.camel@x61.thuisdomein>
Subject: Re: [PATCH -v2 0/3] Use PCIe DSN to improve pciehp_resume
From: Paul Bolle <pebolle@tiscali.nl>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Date: Thu, 11 Jul 2013 16:19:45 +0200
In-Reply-To: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 14:19:45.0452 (UTC) FILETIME=[B1658EC0:01CE7E41]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 17:43 +0800, Yijing Wang wrote:
> v1->v2: Modify pci_get_dsn to pci_device_serial_number,
> 	    power off slot before remove the old device during resume to avoid
> 		old .remove() method to touch new hardware.
> 		Fix other typo and fail check problems.
> 		Split the list_empty() guard into new patch.
> 		
> 
> Yijing Wang (3):
>   PCI: introduce PCIe Device Serial Number Capability support
>   PCI,pciehp: avoid add a device already exist before suspend during
>     resume
>   PCI,pciehp: use PCIe DSN to identify device change during suspend
> 
>  drivers/pci/hotplug/pciehp_core.c |   54 ++++++++++++++++++++++++++++++++++--
>  drivers/pci/pci.c                 |   27 ++++++++++++++++++
>  drivers/pci/probe.c               |    2 +
>  include/linux/pci.h               |    3 ++
>  4 files changed, 83 insertions(+), 3 deletions(-)

Series applies cleanly to v3.10 (but there was a small problem with 3/3,
which I'll mention in a reply to that patch). Compiles without warning.
Those two errors on every resume are now gone!

Thanks.


Paul Bolle

