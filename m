Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936434Ab3DIVgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934470Ab3DIVgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:36:09 -0400
Date: Tue, 9 Apr 2013 23:37:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Cc: Roland Dreier <roland@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Message-ID: <20130409203659.GA9471@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <20130409203409.GA9246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409203409.GA9246@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:34:09PM +0300, Michael S. Tsirkin wrote:
> On Fri, Apr 05, 2013 at 04:17:36PM -0400, Michael R. Hines wrote:
> > The userland part of the patch was missing (IBV_ACCESS_GIFT).
> > 
> > I added flag that to /usr/include in addition to this patch and did
> > a test RDMA migrate and it seems to work without any problems.
> > 
> > I also removed the IBV_*_WRITE flags on the sender-side and
> > activated cgroups with the "memory.memsw.limit_in_bytes" activated
> > and the migration with RDMA also succeeded without any problems
> > (both with *and* without GIFT also worked).
> > 
> > Any additional tests you would like?
> > 
> > 
> > - Michael
> 
> RDMA can't really work with swap so not sure how that's relevant.
> 
> Please check memory.usage_in_bytes - is it lower with
> the GIFT flag?  I think this is what we really care about.

oh and no reason to set memsw.limit_in_bytes I think.

> -- 
> MST
