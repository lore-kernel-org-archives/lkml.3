Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3BCOVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:21:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3BCOVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:21:44 -0500
Date: Sun, 3 Feb 2013 16:21:33 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] AER-KVM: Error containment of VFIO devices
 assigned to KVM guests
Message-ID: <20130203142133.GH23213@redhat.com>
References: <F9E001219150CB45BEDC82A650F360C9014AAEF8@G9W0717.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F9E001219150CB45BEDC82A650F360C9014AAEF8@G9W0717.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please use "git send-email --thread --no-chain-reply-to" when sending
patch series.

On Sun, Feb 03, 2013 at 02:10:08PM +0000, Pandarathil, Vijaymohan R wrote:
> 
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
> [PATCH 1/3] VFIO: Wrapper for getting reference to vfio_device from device 
> [PATCH 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
> [PATCH 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI devices
> 
> Kernel files changed
> 
>  drivers/vfio/vfio.c  | 41 ++++++++++++++++++++++++++++++++---------
>  include/linux/vfio.h |  3 +++
>  2 files changed, 35 insertions(+), 9 deletions(-)
> 
>  drivers/vfio/pci/vfio_pci.c         | 43 ++++++++++++++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_intrs.c   | 30 ++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  include/uapi/linux/vfio.h           |  1 +
>  4 files changed, 74 insertions(+), 1 deletion(-)
> 
> Qemu files changed
> 
>  hw/vfio_pci.c              | 105 +++++++++++++++++++++++++++++++++++++++++++++
>  linux-headers/linux/vfio.h |   1 +
>  2 files changed, 106 insertions(+)

--
			Gleb.
