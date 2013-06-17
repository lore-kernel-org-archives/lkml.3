Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3FQD4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:56:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:37215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab3FQD4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:56:35 -0400
Message-ID: <1371441361.21896.152.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Mon, 17 Jun 2013 13:56:01 +1000
In-Reply-To: <1371438800.22681.38.camel@ul30vt.home>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-16 at 21:13 -0600, Alex Williamson wrote:

> IOMMU groups themselves don't provide security, they're accessed by
> interfaces like VFIO, which provide the security.  Given a brief look, I
> agree, this looks like a possible backdoor.  The typical VFIO way to
> handle this would be to pass a VFIO file descriptor here to prove that
> the process has access to the IOMMU group.  This is how /dev/vfio/vfio
> gains the ability to setup an IOMMU domain an do mappings with the
> SET_CONTAINER ioctl using a group fd.  Thanks,

How do you envision that in the kernel ? IE. I'm in KVM code, gets that
vfio fd, what do I do with it ?

Basically, KVM needs to know that the user is allowed to use that iommu
group. I don't think we want KVM however to call into VFIO directly
right ?

Cheers,
Ben.


