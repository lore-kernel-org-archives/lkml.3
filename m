Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3LaO43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 09:56:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3LaO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 09:56:27 -0500
Date: Tue, 31 Dec 2013 09:51:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yijing Wang <wangyijing@huawei.com>, JBeulich@suse.com
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] xen: Use dev_is_pci() to check whether it is pci device
Message-ID: <20131231145111.GB3349@phenom.dumpdata.com>
References: <1386243245-34280-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386243245-34280-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 07:34:05PM +0800, Yijing Wang wrote:
> Use PCI standard marco dev_is_pci() instead of directly compare
> pci_bus_type to check whether it is pci device.

Jan, you OK with this?

> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/xen/dbgp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/dbgp.c b/drivers/xen/dbgp.c
> index f3ccc80..8145a59 100644
> --- a/drivers/xen/dbgp.c
> +++ b/drivers/xen/dbgp.c
> @@ -19,7 +19,7 @@ static int xen_dbgp_op(struct usb_hcd *hcd, int op)
>  	dbgp.op = op;
>  
>  #ifdef CONFIG_PCI
> -	if (ctrlr->bus == &pci_bus_type) {
> +	if (dev_is_pci(ctrlr)) {
>  		const struct pci_dev *pdev = to_pci_dev(ctrlr);
>  
>  		dbgp.u.pci.seg = pci_domain_nr(pdev->bus);
> -- 
> 1.7.1
> 
> 
