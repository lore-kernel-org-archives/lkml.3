Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3GKOWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:22:16 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58347 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631Ab3GKOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:22:15 -0400
Message-ID: <1373552533.1349.4.camel@x61.thuisdomein>
Subject: Re: [PATCH -v2 1/3] PCI: introduce PCIe Device Serial Number
 Capability support
From: Paul Bolle <pebolle@tiscali.nl>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Date: Thu, 11 Jul 2013 16:22:13 +0200
In-Reply-To: <1373535825-49972-2-git-send-email-wangyijing@huawei.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
	 <1373535825-49972-2-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 14:22:14.0024 (UTC) FILETIME=[09F3D880:01CE7E42]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 17:43 +0800, Yijing Wang wrote:
> Introduce PCIe Ext Capability Device Serial Number support,
> so we can use the unique device serial number to identify
> the physical device. During system suspend, if the PCIe
> device was removed and inserted a new same device, after
> system resume there is no good way to identify it, maybe
> Device Serial Number is a good choice if device support.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/pci.c   |   27 +++++++++++++++++++++++++++
>  drivers/pci/probe.c |    2 ++
>  include/linux/pci.h |    3 +++
>  3 files changed, 32 insertions(+), 0 deletions(-)
>
[...] 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0fd1f15..10d190b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -342,6 +342,7 @@ struct pci_dev {
>  	struct list_head msi_list;
>  	struct kset *msi_kset;
>  #endif
> +	u64 sn;		/* device serieal number, 0 if not support */

Typo: serieal

>  	struct pci_vpd *vpd;
>  #ifdef CONFIG_PCI_ATS
>  	union {

[...]


Paul Bolle

