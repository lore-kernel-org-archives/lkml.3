Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab3CUJjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab3CUJjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:39:18 -0400
Date: Thu, 21 Mar 2013 11:39:47 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Message-ID: <20130321093946.GG28328@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
 <20130321085107.GE28328@redhat.com>
 <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:13:38AM -0700, Roland Dreier wrote:
> On Thu, Mar 21, 2013 at 1:51 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> In that case, no, I don't see any reason for LOCAL_WRITE, since the
> >> only RDMA operations that will access this memory are remote reads.
> >
> > What is the meaning of LOCAL_WRITE then? There are no local
> > RDMA writes as far as I can see.
> 
> Umm, it means you're giving the local adapter permission to write to
> that memory.  So you can use it as a receive buffer or as the target
> for remote data from an RDMA read operation.

Well RDMA read has it's own flag, IB_ACCESS_REMOTE_READ.
I don't see why do you need to give adapter permission
to use memory as a receive buffer given that
you must pass the address in the post receive verb,
but maybe that's what the IB spec says so that's what
the applications assumed?

> > OK then what we need is a new flag saying "I really do not
> > intend to write into this memory please do not break
> > COW or do anything else just in case I do".
> 
> Isn't that a shared read-only mapping?
> 
>  - R.

Nothing to do with how the page is mapped.  We can and do write the page
before registration. BTW umem.c passes in force so it breaks COW
even for read-only mappings, right?

-- 
MST
