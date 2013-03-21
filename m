Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3CUSCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab3CUSCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:02:46 -0400
Date: Thu, 21 Mar 2013 20:03:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Roland Dreier <roland@kernel.org>,
        "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Message-ID: <20130321180300.GB4366@redhat.com>
References: <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
 <20130321085107.GE28328@redhat.com>
 <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
 <20130321093946.GG28328@redhat.com>
 <20130321171115.GA653@obsidianresearch.com>
 <20130321171525.GE2994@redhat.com>
 <20130321172150.GA3118@obsidianresearch.com>
 <20130321174237.GA4060@redhat.com>
 <20130321175732.GA3263@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321175732.GA3263@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:57:32AM -0600, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 07:42:37PM +0200, Michael S. Tsirkin wrote:
> 
> > It doesn't actually, and our app would sometimes write to these pages.
> > It simply does not care which version does the remote get in this case
> > since we track writes and resend later.
> 
> Heh, somehow I thought you might say that :)
> 
> A new flag seems like the only way then - maybe:
>   IBV_ACCESS_NON_COHERENT - The adaptor and the CPU do not share
>      a coherent view of registered memory. Memory writes from the CPU
>      after ibv_reg_mr completes may not be reflected in the memory
>      viewed by the adaptor.
> 
>      Can only be combined with read only access permissions.
> 
> Jason

I kind of like _GIFT for name, gifts are nice :) But yes that's exactly
the semantics we need.

-- 
MST
