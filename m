Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaGKJla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:41:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46383 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaGKJl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:41:26 -0400
X-IronPort-AV: E=Sophos;i="5.01,642,1400025600"; 
   d="scan'208";a="151710690"
Message-ID: <53BFB13E.1060505@citrix.com>
Date: Fri, 11 Jul 2014 10:41:18 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.zhao@oracle.com>, <bhelgaas@google.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <gleb@kernel.org>, <pbonzini@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <jesse.brandeburg@intel.com>,
        <bruce.w.allan@intel.com>, <carolyn.wyborny@intel.com>,
        <donald.c.skidmore@intel.com>, <gregory.v.rose@intel.com>,
        <alexander.h.duyck@intel.com>, <john.ronciak@intel.com>,
        <mitch.a.williams@intel.com>, <alex.williamson@redhat.com>
CC: <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>, <linux.nics@intel.com>,
        <e1000-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ethan.kernel@gmail.com>,
        <vaughan.cao@oracle.com>
Subject: Re: [PATCH 1/2 V2] PCI: introduce device assignment interface and
 refactory related code
References: <1405057961-7234-1-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1405057961-7234-1-git-send-email-ethan.zhao@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 06:52, Ethan Zhao wrote:
> 
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
>  	xen_pcibk_config_free_dyn_fields(dev);
>  	xen_pcibk_config_free_dev(dev);
>  
> -	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_sriov_deassign_device(dev);
>  	pci_dev_put(dev);
>  
>  	kfree(psdev);
> @@ -404,7 +404,7 @@ static int pcistub_init_device(struct pci_dev *dev)
>  	dev_dbg(&dev->dev, "reset device\n");
>  	xen_pcibk_reset_device(dev);
>  
> -	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
> +	pci_sriov_assign_device(dev);
>  	return 0;

Xen's PCI passthrough works with all PCI devices not just SR-IOV ones,
so the naming of the helpers isn't correct.

David
