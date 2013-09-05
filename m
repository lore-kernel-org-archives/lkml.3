Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3IENJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:09:08 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57200 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3IENJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:09:05 -0400
Date: Thu, 5 Sep 2013 09:09:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130905130902.GA26314@htj.dyndns.org>
References: <cover.1378383792.git.agordeev@redhat.com>
 <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Thu, Sep 05, 2013 at 02:52:47PM +0200, Alexander Gordeev wrote:
> -int pci_enable_msi_block_part(struct pci_dev *dev,
> -			      unsigned int nvec, int nvec_mme)
> +int pci_get_msi_cap(struct pci_dev *dev)
>  {
> -	int status, maxvec;
> +	int ret;
>  	u16 msgctl;
>  
>  	if (!dev->msi_cap)
>  		return -EINVAL;
>  
>  	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
> -	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pci_get_msi_cap);

One curiosity - with the above factored out, is
pci_enable_msi_block_part() returning positive number still necessary?
I followed most of code paths in x86 and nothing seems to need it and
positive return seems to be just causing confusion - ie. returning 1
on multiple msi config failure from some functions, which is silly.

Thanks.

-- 
tejun
