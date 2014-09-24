Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaIXR4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:56:35 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54261 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaIXR4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:56:32 -0400
Date: Wed, 24 Sep 2014 11:56:29 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Francesco Ruggeri <fruggeri@aristanetworks.com>
Cc: linux-pci@vger.kernel.org, sbhatewara@vmware.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] pci: move PCI_VENDOR_ID_VMWARE to pci_ids.h
Message-ID: <20140924175629.GD20416@google.com>
References: <20140924172923.D112148565B@fruggeri-Arora18.sjc.aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924172923.D112148565B@fruggeri-Arora18.sjc.aristanetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:29:23AM -0700, Francesco Ruggeri wrote:
> From b99b1ec156ab351668eb77a00a57a4ae095eec28 Mon Sep 17 00:00:00 2001
> From: Francesco Ruggeri <fruggeri@arista.com>
> Date: Wed, 24 Sep 2014 10:12:41 -0700
> Subject: [PATCH 1/1] pci: move PCI_VENDOR_ID_VMWARE to pci_ids.h
> 
> Moving PCI_VENDOR_ID_VMWARE from device specific files to pci_ids.h.
> It is useful to always have access to it, especially when accessing
> subsystem_vendor_id on emulated devices.
> 
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

Applied to pci/misc for v3.18, thanks!

> ---
>  drivers/gpu/drm/vmwgfx/svga_reg.h  | 1 -
>  drivers/misc/vmw_vmci/vmci_guest.c | 1 -
>  drivers/net/vmxnet3/vmxnet3_int.h  | 1 -
>  drivers/scsi/vmw_pvscsi.h          | 1 -
>  include/linux/pci_ids.h            | 2 ++
>  5 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/svga_reg.h b/drivers/gpu/drm/vmwgfx/svga_reg.h
> index 11323dd..e4259c2 100644
> --- a/drivers/gpu/drm/vmwgfx/svga_reg.h
> +++ b/drivers/gpu/drm/vmwgfx/svga_reg.h
> @@ -35,7 +35,6 @@
>  /*
>   * PCI device IDs.
>   */
> -#define PCI_VENDOR_ID_VMWARE            0x15AD
>  #define PCI_DEVICE_ID_VMWARE_SVGA2      0x0405
>  
>  /*
> diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
> index 248399a..189b325 100644
> --- a/drivers/misc/vmw_vmci/vmci_guest.c
> +++ b/drivers/misc/vmw_vmci/vmci_guest.c
> @@ -35,7 +35,6 @@
>  #include "vmci_driver.h"
>  #include "vmci_event.h"
>  
> -#define PCI_VENDOR_ID_VMWARE		0x15AD
>  #define PCI_DEVICE_ID_VMWARE_VMCI	0x0740
>  
>  #define VMCI_UTIL_NUM_RESOURCES 1
> diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
> index 3759479..5f0199f 100644
> --- a/drivers/net/vmxnet3/vmxnet3_int.h
> +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> @@ -117,7 +117,6 @@ enum {
>  /*
>   * PCI vendor and device IDs.
>   */
> -#define PCI_VENDOR_ID_VMWARE            0x15AD
>  #define PCI_DEVICE_ID_VMWARE_VMXNET3    0x07B0
>  #define MAX_ETHERNET_CARDS		10
>  #define MAX_PCI_PASSTHRU_DEVICE		6
> diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
> index ce45888..ee16f0c 100644
> --- a/drivers/scsi/vmw_pvscsi.h
> +++ b/drivers/scsi/vmw_pvscsi.h
> @@ -32,7 +32,6 @@
>  
>  #define MASK(n)        ((1 << (n)) - 1)        /* make an n-bit mask */
>  
> -#define PCI_VENDOR_ID_VMWARE		0x15AD
>  #define PCI_DEVICE_ID_VMWARE_PVSCSI	0x07C0
>  
>  /*
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 6ed0bb7..e62b20a 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2971,4 +2971,6 @@
>  
>  #define PCI_VENDOR_ID_OCZ		0x1b85
>  
> +#define PCI_VENDOR_ID_VMWARE		0x15AD
> +
>  #endif /* _LINUX_PCI_IDS_H */
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
