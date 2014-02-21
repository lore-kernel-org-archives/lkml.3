Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaBUBSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:18:30 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:32952 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaBUBS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:18:29 -0500
Message-ID: <5306A937.1040707@huawei.com>
Date: Fri, 21 Feb 2014 09:17:43 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Howells <dhowells@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] frv: replace now removed pci_bus_b() causing build failure
References: <1392918366-19079-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1392918366-19079-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I'm sorry, Paul,thanks for your patch to correct this.

On 2014/2/21 1:46, Paul Gortmaker wrote:
> In commit 94e6a9b93064b49024b8701d2d81fcb4a821fa09 ("PCI: Remove
> pci_bus_b() and use list_for_each_entry() directly") the function
> pci_bus_b() was removed, but one instance of its usage was missed.
> 
> Replace it in the same fashion that the original commit did.
> 
> Cc: Yijing Wang <wangyijing@huawei.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [Note: commit ID referenced above is from linux-next and will
>  be invalid if the PCI-next content is ever rebased.]
> 
>  arch/frv/mb93090-mb00/pci-frv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
> index c28121765448..67b1d1685759 100644
> --- a/arch/frv/mb93090-mb00/pci-frv.c
> +++ b/arch/frv/mb93090-mb00/pci-frv.c
> @@ -88,7 +88,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
>  
>  	/* Depth-First Search on bus tree */
>  	for (ln=bus_list->next; ln != bus_list; ln=ln->next) {
> -		bus = pci_bus_b(ln);
> +		bus = list_entry(ln, struct pci_bus, node);
>  		if ((dev = bus->self)) {
>  			for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
>  				r = &dev->resource[idx];
> 


-- 
Thanks!
Yijing

