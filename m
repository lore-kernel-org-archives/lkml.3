Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab3FLDPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:15:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:34203 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab3FLDPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:15:16 -0400
Message-ID: <1371006871.8250.168.camel@pasglop>
Subject: Re: [PATCH 0/4 v3] KVM: PPC: IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Wed, 12 Jun 2013 13:14:31 +1000
In-Reply-To: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 16:11 +1000, Alexey Kardashevskiy wrote:
> Ben, ping! :)
> 
> This series has tiny fixes (capability and ioctl numbers,
> changed documentation, compile errors in some configuration).
> More details are in the commit messages.
> Rebased on v3.10-rc4.

Alex, I assume you'll merge that once I ack it ?

Cheers,
Ben.

> 
> Alexey Kardashevskiy (4):
>   KVM: PPC: Add support for multiple-TCE hcalls
>   powerpc: Prepare to support kernel handling of IOMMU map/unmap
>   KVM: PPC: Add support for IOMMU in-kernel handling
>   KVM: PPC: Add hugepage support for IOMMU in-kernel handling
> 
>  Documentation/virtual/kvm/api.txt        |   45 +++
>  arch/powerpc/include/asm/kvm_host.h      |    7 +
>  arch/powerpc/include/asm/kvm_ppc.h       |   40 ++-
>  arch/powerpc/include/asm/pgtable-ppc64.h |    4 +
>  arch/powerpc/include/uapi/asm/kvm.h      |    7 +
>  arch/powerpc/kvm/book3s_64_vio.c         |  398 ++++++++++++++++++++++++-
>  arch/powerpc/kvm/book3s_64_vio_hv.c      |  471 ++++++++++++++++++++++++++++--
>  arch/powerpc/kvm/book3s_hv.c             |   39 +++
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S  |    6 +
>  arch/powerpc/kvm/book3s_pr_papr.c        |   37 ++-
>  arch/powerpc/kvm/powerpc.c               |   15 +
>  arch/powerpc/mm/init_64.c                |   77 ++++-
>  include/uapi/linux/kvm.h                 |    3 +
>  13 files changed, 1121 insertions(+), 28 deletions(-)
> 


