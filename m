Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3CUSlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:41:53 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60334 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3CUSlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:41:51 -0400
Date: Thu, 21 Mar 2013 12:41:35 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Roland Dreier <roland@kernel.org>,
        "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Message-ID: <20130321184135.GA8044@obsidianresearch.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
 <20130321085107.GE28328@redhat.com>
 <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
 <20130321093946.GG28328@redhat.com>
 <20130321171115.GA653@obsidianresearch.com>
 <20130321181633.GC4366@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321181633.GC4366@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 08:16:33PM +0200, Michael S. Tsirkin wrote:

> This is the one I find redundant. Since the write will be done by
> the adaptor under direct control by the application, why does it
> make sense to declare this beforehand?  If you don't want to allow
> local write access to memory, just do not post any receive WRs with
> this address.  If you posted and regret it, reset the QP to cancel.

This is to support your COW scenario - the app declares before hand to
the kernel that it will write to the memory and the kernel ensures
pages are dedicated to the app at registration time. Or the app says
it will only read and the kernel could leave them shared.

The adaptor enforces the access control to prevent a naughty app from
writing to shared memory - think about mmap'ing libc.so and then using
RDMA to write to the shared pages. It is necessary to ensure that is
impossible.

Jason
