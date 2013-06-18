Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3FRCdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab3FRCdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:33:06 -0400
Message-ID: <1371522772.22681.140.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Mon, 17 Jun 2013 20:32:52 -0600
In-Reply-To: <1371441361.21896.152.camel@pasglop>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 13:56 +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2013-06-16 at 21:13 -0600, Alex Williamson wrote:
> 
> > IOMMU groups themselves don't provide security, they're accessed by
> > interfaces like VFIO, which provide the security.  Given a brief look, I
> > agree, this looks like a possible backdoor.  The typical VFIO way to
> > handle this would be to pass a VFIO file descriptor here to prove that
> > the process has access to the IOMMU group.  This is how /dev/vfio/vfio
> > gains the ability to setup an IOMMU domain an do mappings with the
> > SET_CONTAINER ioctl using a group fd.  Thanks,
> 
> How do you envision that in the kernel ? IE. I'm in KVM code, gets that
> vfio fd, what do I do with it ?
> 
> Basically, KVM needs to know that the user is allowed to use that iommu
> group. I don't think we want KVM however to call into VFIO directly
> right ?

Right, we don't want to create dependencies across modules.  I don't
have a vision for how this should work.  This is effectively a complete
side-band to vfio, so we're really just dealing in the iommu group
space.  Maybe there needs to be some kind of registration of ownership
for the group using some kind of token.  It would need to include some
kind of notification when that ownership ends.  That might also be a
convenient tag to toggle driver probing off for devices in the group.
Other ideas?  Thanks,

Alex

