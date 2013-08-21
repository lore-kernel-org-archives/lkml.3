Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3HUNhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:37:36 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36555 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab3HUNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:37:35 -0400
Date: Wed, 21 Aug 2013 06:37:34 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        Greg KH <gregkh@linuxfoundation.org>
Message-ID: <1944820276.33601674.1377092254160.JavaMail.root@vmware.com>
In-Reply-To: <20130821.000255.1258155583733908892.davem@davemloft.net>
References: <1377020012-1839-1-git-send-email-acking@vmware.com> <20130821.000255.1258155583733908892.davem@davemloft.net>
Subject: Re: [PATCH] VMXNET3: Add support for virtual IOMMU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.67]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC28 (Linux)/8.0.3_GA_5664)
Thread-Topic: VMXNET3: Add support for virtual IOMMU
Thread-Index: iteshscowKzxVYPIJWS3nHbeGVswJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Greg, since this will apply to a similar patchset I sent out
for VMCI.

----- Original Message -----
> From: Andy King <acking@vmware.com>
> Date: Tue, 20 Aug 2013 10:33:32 -0700
> 
> > We can't just do virt_to_phys() on memory that we pass to the device and
> > expect it to work in presence of a virtual IOMMU.  We need to add IOMMU
> > mappings for such DMAs to work correctly.  Fix that with
> > pci_alloc_consistent() where possible, or pci_map_single() where the
> > mapping is short-lived or we don't control the allocation (netdev).
>
> Please use dma_alloc_coherent() (or in fact dma_zalloc_coherent()),
> dma_map_single() et al., because they are preferred and in particular
> allow specification of GFP_* flags

Sorry about that, I'll fix that and send out a new patch.

Thanks!
- Andy
