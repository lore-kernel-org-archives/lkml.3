Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3HUNnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:43:42 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36631 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab3HUNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:43:41 -0400
Date: Wed, 21 Aug 2013 06:43:38 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: gregkh@linuxfoundation.org
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>
Message-ID: <1988970649.33605490.1377092618300.JavaMail.root@vmware.com>
In-Reply-To: <1377019803-1490-1-git-send-email-acking@vmware.com>
References: <1377019803-1490-1-git-send-email-acking@vmware.com>
Subject: Re: [PATCH 0/2] VMCI: Add support for virtual IOMMU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.67]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC28 (Linux)/8.0.3_GA_5664)
Thread-Topic: VMCI: Add support for virtual IOMMU
Thread-Index: gQlarTO3q6Sq8vyjlRbxANz4Gd7mjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I'd like to withdraw this in light of DaveM's comments on
a similar patch to vmxnet3 regarding dma_alloc_coherent() vs
pci_alloc_consistent().  I'll fix it and send out a new patchset.

Sorry about this!

Thanks!
- Andy

----- Original Message -----
> This patchset adds support for virtual IOMMU to the VMCI module.  We switch
> to
> DMA consistent mappings for queuepair and doorbell pages that are passed to
> the
> device, which allows the module to work in the presence of vIOMMU/VT-d.
> 
> Andy King (2):
>   VMCI: Remove non-blocking/pinned queuepair support
>   VMCI: Add support for virtual IOMMU
> 
>  drivers/misc/vmw_vmci/vmci_driver.c     |    2 +-
>  drivers/misc/vmw_vmci/vmci_driver.h     |    7 +
>  drivers/misc/vmw_vmci/vmci_guest.c      |   21 ++-
>  drivers/misc/vmw_vmci/vmci_queue_pair.c |  312
>  ++++++++++++-------------------
>  drivers/misc/vmw_vmci/vmci_queue_pair.h |   18 --
>  5 files changed, 140 insertions(+), 220 deletions(-)
> 
> --
> 1.7.4.1
> 
