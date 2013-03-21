Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3CUHDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3CUHD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:03:29 -0400
Date: Thu, 21 Mar 2013 09:03:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Message-ID: <20130321070357.GD28328@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:55:54PM -0700, Roland Dreier wrote:
> On Wed, Mar 20, 2013 at 11:18 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > core/umem.c seems to get the arguments to get_user_pages
> > in the reverse order: it sets writeable flag and
> > breaks COW for MAP_SHARED if and only if hardware needs to
> > write the page.
> >
> > This breaks memory overcommit for users such as KVM:
> > each time we try to register a page to send it to remote, this
> > breaks COW.  It seems that for applications that only have
> > REMOTE_READ permission, there is no reason to break COW at all.
> 
> I proposed a similar (but not exactly the same, see below) patch a
> while ago: https://lkml.org/lkml/2012/1/26/7 but read the thread,
> especially https://lkml.org/lkml/2012/2/6/265
> 
> I think this change will break the case where userspace tries to
> register an MR with read-only permission, but intends locally through
> the CPU to write to the memory.

Shouldn't it set LOCAL_WRITE then?
