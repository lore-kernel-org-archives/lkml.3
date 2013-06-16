Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3FPWjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:39:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:32769 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3FPWje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:39:34 -0400
Message-ID: <1371422343.21896.143.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Date: Mon, 17 Jun 2013 08:39:03 +1000
In-Reply-To: <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 16:11 +1000, Alexey Kardashevskiy wrote:
> +long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
> +               struct kvm_create_spapr_tce_iommu *args)
> +{
> +       struct kvmppc_spapr_tce_table *tt = NULL;
> +       struct iommu_group *grp;
> +       struct iommu_table *tbl;
> +
> +       /* Find an IOMMU table for the given ID */
> +       grp = iommu_group_get_by_id(args->iommu_id);
> +       if (!grp)
> +               return -ENXIO;
> +
> +       tbl = iommu_group_get_iommudata(grp);
> +       if (!tbl)
> +               return -ENXIO;

So Alex Graf pointed out here, there is a security issue here, or are we
missing something ?

What prevents a malicious program that has access to /dev/kvm from
taking over random iommu groups (including host used ones) that way?

What is the security model of that whole iommu stuff to begin with ?

Cheers,
Ben.


