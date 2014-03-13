Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbaCMEMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:12:38 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64621 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaCMEMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:12:36 -0400
Date: Wed, 12 Mar 2014 22:12:31 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 0/2] block: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140313041231.GC26657@google.com>
References: <cover.1393404496.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1393404496.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:02:40AM +0100, Alexander Gordeev wrote:
> Changes since v1:
>   - cciss: patch #1: a weird 'goto' removed;
>   - cciss: patch #2: pci_enable_msix_exact() used, not pci_enable_msix_range();
>   - rsxx: patch dropped - no need to change anything;
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> This change updates 'cciss' only, but there is also 'nvme' update
> pending - I am waiting for Intel guys to clarify if they want to
> route it thru their tree. If not, I will post the 'nvme' patch as
> a follow-up to this series.

Hi Jens,

I'd like to get these merged during the v3.15 merge window.  I'd be glad to
review and apply them through my tree, unless you want to do it.  They do
depend on f7fc32c, which went in after the v3.14 merge window, which makes
it a bit of a hassle.

So let me know if you'd rather handle these; otherwise I'll review them and
put them in my tree next week.

I'll include the nvme update, since it has Keith's "Reviewed-by".

Bjorn

> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: iss_storagedev@hp.com
> Cc: linux-pci@vger.kernel.org
> 
> Alexander Gordeev (2):
>   cciss: Fallback to MSI rather than to INTx if MSI-X failed
>   cciss: Use pci_enable_msix_exact() instead of pci_enable_msix()
> 
>  drivers/block/cciss.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
