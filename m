Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3FTHsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:48:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:55231 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab3FTHsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:48:13 -0400
Message-ID: <1371714449.3944.14.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Date: Thu, 20 Jun 2013 17:47:29 +1000
In-Reply-To: <20130620052822.GB3140@voom.redhat.com>
References: <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
	 <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au>
	 <1371617970.21896.232.camel@pasglop>
	 <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
	 <1371653443.21896.291.camel@pasglop>
	 <1371656989.22659.98.camel@ul30vt.home> <51C28BEA.8050501@ozlabs.ru>
	 <20130620052822.GB3140@voom.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 15:28 +1000, David Gibson wrote:
> > Just out of curiosity - would not get_file() and fput_atomic() on a
> group's
> > file* do the right job instead of vfio_group_add_external_user() and
> > vfio_group_del_external_user()?
> 
> I was thinking that too.  Grabbing a file reference would certainly be
> the usual way of handling this sort of thing.

But that wouldn't prevent the group ownership to be returned to
the kernel or another user would it ?

Ben.


