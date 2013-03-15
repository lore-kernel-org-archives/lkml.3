Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3COUP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab3COUPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:15:54 -0400
Message-ID: <1363378546.16793.26.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: include <linux/slab.h> for kmalloc
From: Alex Williamson <alex.williamson@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Date: Fri, 15 Mar 2013 14:15:46 -0600
In-Reply-To: <1363298204-8014-6-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
	 <1363298204-8014-6-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 22:56 +0100, Arnd Bergmann wrote:
> The vfio drivers call kmalloc or kzalloc, but do not
> include <linux/slab.h>, which causes build errors on
> ARM.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
> Please apply for 3.9

Applied, Thanks,

Alex

>  drivers/vfio/pci/vfio_pci_config.c | 1 +
>  drivers/vfio/pci/vfio_pci_intrs.c  | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 964ff22..aeb00fc 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -27,6 +27,7 @@
>  #include <linux/pci.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
> +#include <linux/slab.h>
>  
>  #include "vfio_pci_private.h"
>  
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 3639371..a965091 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -22,6 +22,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/workqueue.h>
> +#include <linux/slab.h>
>  
>  #include "vfio_pci_private.h"
>  



