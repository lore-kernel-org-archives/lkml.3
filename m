Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab3CLVIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933487Ab3CLVIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:08:09 -0400
Message-ID: <1363122484.24132.113.camel@bling.home>
Subject: Re: [PATCH v7 0/3] AER-KVM: Error containment of VFIO devices
 assigned to KVM guests
From: Alex Williamson <alex.williamson@redhat.com>
To: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Cc: gleb@redhat.com, bhelgaas@google.com, blauwirbel@gmail.com,
        lance.oritz@hp.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 15:08:04 -0600
In-Reply-To: <1362815537-27303-1-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1362815537-27303-1-git-send-email-vijaymohan.pandarathil@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-09 at 01:52 -0600, Vijay Mohan Pandarathil wrote:
> Add support for error containment when a VFIO device assigned to a KVM
> guest encounters an error. This is for PCIe devices/drivers that support AER
> functionality. When the host OS is notified of an error in a device either
> through the firmware first approach or through an interrupt handled by the AER
> root port driver, the error handler registered by the vfio-pci driver gets
> invoked. The qemu process is signaled through an eventfd registered per
> VFIO device by the qemu process. In the eventfd handler, qemu decides on
> what action to take. In this implementation, guest is brought down to
> contain the error.
> 
> 
> v7:
>  - Rebased to latest upstream
>  - Used device_lock() for synchronising err_trigger access
> v6:
>  - Rebased to latest upstream
>  - Resolved merge conflict with vfio_dev_present()
> v5:
>  - Rebased to latest upstream stable bits
>  - Incorporated v4 feedback
> v4:
>  - Stop the guest instead of terminating
>  - Remove unwanted returns from functions
>  - Incorporate other feedback
> v3:
>  - Removed PCI_AER* flags from device info ioctl.
>  - Incorporated feedback
> v2:
>  - Rebased to latest upstream stable bits
>  - Changed the new ioctl to be part of VFIO_SET_IRQs ioctl
>  - Added a new patch to get/put reference to a vfio device from struct device
>  - Incorporated all other feedback.
> 
> ---
> 
> Vijay Mohan Pandarathil(3):
> 
> [PATCH 1/3] VFIO: Wrapper to get reference to vfio_device from device 
> [PATCH 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
> [PATCH 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI devices
> 
> Kernel files changed
> 
>  drivers/vfio/vfio.c  | 30 +++++++++++++++++++++++++++++-
>  include/linux/vfio.h |  3 +++
>  2 files changed, 32 insertions(+), 1 deletion(-)
> 
>  drivers/vfio/pci/vfio_pci.c         | 44 ++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_intrs.c   | 64 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  include/uapi/linux/vfio.h           |  1 +
>  4 files changed, 109 insertions(+), 1 deletion(-)

Applied 1 & 2 to my next tree, patch 3 is qemu and depends on the vfio.h
change getting into mainline so will need to be re-sent once that
happens.  Thanks,

Alex

> Qemu files changed
> 
>  hw/vfio_pci.c              | 123 +++++++++++++++++++++++++++++++++++++++++++++
>  linux-headers/linux/vfio.h |   1 +
>  2 files changed, 124 insertions(+)



