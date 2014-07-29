Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaG2Cb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:31:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaG2Cb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:31:26 -0400
Message-ID: <1406601073.1011.157.camel@ul30vt.home>
Subject: Re: [PATCH 1/4] PCI: introduce helper functions for device flag
 operation
From: Alex Williamson <alex.williamson@redhat.com>
To: ethan zhao <ethan.zhao@oracle.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Date: Mon, 28 Jul 2014 20:31:13 -0600
In-Reply-To: <53D6FE95.6040605@oracle.com>
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>
	  <1406045944-1587-2-git-send-email-ethan.zhao@oracle.com>
	 <1406581206.1011.133.camel@ul30vt.home> <53D6FE95.6040605@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 09:53 +0800, ethan zhao wrote:
> On 2014/7/29 5:00, Alex Williamson wrote:
> > On Wed, 2014-07-23 at 00:19 +0800, Ethan Zhao wrote:
> >> This patch introduced three helper functions to hide direct
> >> device flag operation.
> >>
> >> void pci_set_dev_assigned(struct pci_dev *pdev);
> >> void pci_set_dev_deassigned(struct pci_dev *pdev);
> >> bool pci_is_dev_assigned(struct pci_dev *pdev);
> >>
> >> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> >> ---
> >>   include/linux/pci.h |   13 +++++++++++++
> >>   1 files changed, 13 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index aab57b4..5f6f8fa 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -1129,6 +1129,19 @@ resource_size_t pcibios_window_alignment(struct pci_bus *bus,
> >>   
> >>   int pci_set_vga_state(struct pci_dev *pdev, bool decode,
> >>   		      unsigned int command_bits, u32 flags);
> >> +/* helper functions for operation of device flag */
> >> +static inline void pci_set_dev_assigned(struct pci_dev *pdev)
> >> +{
> >> +	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
> >> +}
> >> +static inline void pci_set_dev_deassigned(struct pci_dev *pdev)
> >> +{
> >> +	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> >> +}
> > I think pci_clear_dev_assigned() would make more sense, we're not
> > setting a flag named DEASSIGNED.
>    Though it is a flag operation now, may not later, we define it 
> because we want to hide the internal operation.
>    'set' to 'deassigned'  status is enough. So I would like keep it.

I disagree, the opposite of a 'set' is a 'clear', or at least an
'unset'.  Using bit-ops-like terminology doesn't lock us into an
implementation.  As written, this could just as easily be setting two
different variables.

> >
> >> +static inline bool pci_is_dev_assigned(struct pci_dev *pdev)
> >> +{
> >> +	return pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED ? true : false;
> >> +}
> > The ternary operation isn't necessary.  Thanks,
>    Yep,
> 
>    return pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED
> 
>    is enough.
> 
>    Thanks,
>    Ethan
> >
> > Alex
> >
> >>   /* kmem_cache style wrapper around pci_alloc_consistent() */
> >>   
> >>   #include <linux/pci-dma.h>
> >
> >
> 



