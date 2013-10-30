Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3J3SDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab3J3SDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:03:23 -0400
Message-ID: <527149E3.9040607@redhat.com>
Date: Wed, 30 Oct 2013 19:03:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, gleb@redhat.com, aik@ozlabs.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM noncoherent DMA registration and VFIO pseudo
 device
References: <20131030165234.31949.70266.stgit@bling.home>
In-Reply-To: <20131030165234.31949.70266.stgit@bling.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 18:02, Alex Williamson ha scritto:
> v2:
>   - Drop KVM device changes
>   - Add kfree(dev) in destroy function
>   - Add atomic_set(,0) in kvm_arch init
> 
> As described in v1 and discussion, this adds a VFIO pseudo device to
> KVM through which userspace can register VFIO groups.  The initial use
> of this interface is to enable emulation of coherency instructions on
> x86 when a VFIO group is attached.  Future patches will allow KVM to
> query the coherency state of the IOMMU domain used by the group to
> avoid unnecessarily enabling this emulation.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (3):
>       kvm: Add VFIO device
>       kvm/x86: Convert iommu_flags to iommu_noncoherent
>       kvm: Create non-coherent DMA registeration
> 
> 
>  Documentation/virtual/kvm/devices/vfio.txt |   22 ++
>  arch/ia64/include/asm/kvm_host.h           |    2 
>  arch/x86/include/asm/kvm_host.h            |    4 
>  arch/x86/kvm/Kconfig                       |    1 
>  arch/x86/kvm/Makefile                      |    2 
>  arch/x86/kvm/vmx.c                         |    3 
>  arch/x86/kvm/x86.c                         |   22 ++
>  include/linux/kvm_host.h                   |   23 ++
>  include/uapi/linux/kvm.h                   |    4 
>  virt/kvm/Kconfig                           |    3 
>  virt/kvm/iommu.c                           |   22 +-
>  virt/kvm/kvm_main.c                        |    5 +
>  virt/kvm/vfio.c                            |  264 ++++++++++++++++++++++++++++
>  13 files changed, 359 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
>  create mode 100644 virt/kvm/vfio.c
> 

Applied to kvm/queue, thanks.

Paolo
