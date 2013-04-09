Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895Ab3DIUCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761961Ab3DIUCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:02:10 -0400
Date: Tue, 9 Apr 2013 22:00:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Cc: Roland Dreier <roland@kernel.org>, qemu-devel@nongnu.org,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Message-ID: <20130409190011.GA8212@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3A0F.5030507@linux.vnet.ibm.com>
 <20130409163929.GA7661@redhat.com>
 <51645630.3030608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51645630.3030608@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:56:00PM -0400, Michael R. Hines wrote:
> On 04/09/2013 12:39 PM, Michael S. Tsirkin wrote:
> >On Fri, Apr 05, 2013 at 04:54:39PM -0400, Michael R. Hines wrote:
> >>To be more specific, here's what I did:
> >>
> >>1. apply kernel module patch - re-insert module
> >>1. QEMU does: ibv_reg_mr(........IBV_ACCESS_GIFT | IBV_ACCESS_REMOTE_READ)
> >>2. Start the RDMA migration
> >>3. Migration completes without any errors
> >>
> >>This test does *not* work with a cgroup swap limit, however. The
> >>process gets killed. (Both with and without GIFT)
> >>
> >>- Michael
> >Try to attach a debugger and see where it is when it gets killed?
> >
> 
> It's killed by cgroups - not a CPU exception.
> 
> The same test works fine using TCP migration with cgroups -
> everything is fine there.
> 
> The memory that RDMA attempted to register hits some kind of cgroups policy
> which results in a kernel message saying that the cgroup swap limit was hit
> and then it goes ahead and kills the process altogether.
> 
> It's not a QEMU problem - it seems to be a kernel bug.

Maybe cgroup swap limit really is buggy. That's interesting, but not
really related to this patch.  What's interesting is whether we save
lots memory by using this patch.
Couldn't you dump the pagemap for the qemu process and calculate real
memory usage before and after applying the patch?


-- 
MST
