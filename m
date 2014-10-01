Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaJAROb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:14:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaJAROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:14:30 -0400
Message-ID: <1412183666.7360.226.camel@ul30vt.home>
Subject: Re: [PATCH] vfio/pci: Add missing linux/irq.h include
From: Alex Williamson <alex.williamson@redhat.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2014 11:14:26 -0600
In-Reply-To: <1412164818-18211-1-git-send-email-thierry.reding@gmail.com>
References: <1412164818-18211-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 14:00 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This code uses the irq_get_msi_desc() function whose prototype is in
> linux/irq.h. Include this header to fix a build failure.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index a068bb0d69e5..d6f097b0e0e3 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -15,6 +15,7 @@
>  
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/eventfd.h>
>  #include <linux/msi.h>
>  #include <linux/pci.h>

Hi Thierry, thanks for the patch.  The call to irq_get_msi_desc()
actually came in as part of a conflict resolution in the next tree.
I've requested that the next spin of linux-next include this header if
the conflict still exists, but I'm also working to make the conflict go
away along with the function call that requires this additional header.
Thanks,

Alex

