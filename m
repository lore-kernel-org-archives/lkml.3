Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3KTQSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:18:14 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:41540 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab3KTQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:18:12 -0500
Date: Wed, 20 Nov 2013 11:18:08 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 09/29] PCI/MSI: Factor out pci_get_msi_cap()
 interface
Message-ID: <20131120161808.GI28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <85500e7239fcb104df091bbfa873eef8ae654772.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85500e7239fcb104df091bbfa873eef8ae654772.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 18, 2013 at 07:12:09PM +0200, Alexander Gordeev wrote:
> +If this function returns a negative number, it indicates the device is
> +not capable of sending MSIs.

Wouldn't "errno" better describe the error return rather than
"negative number"?

> @@ -795,6 +795,21 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  	return 0;
>  }

We probably want a function comment here?

> +int pci_get_msi_cap(struct pci_dev *dev)
> +{
> +	int ret;
> +	u16 msgctl;
> +
> +	if (!dev->msi_cap)
> +		return -EINVAL;
> +
> +	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
> +	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pci_get_msi_cap);

Other than that,

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
