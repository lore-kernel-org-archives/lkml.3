Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab3DIRja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab3DIRj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:39:28 -0400
Date: Tue, 9 Apr 2013 19:39:30 +0300
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
Message-ID: <20130409163929.GA7661@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3A0F.5030507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515F3A0F.5030507@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 04:54:39PM -0400, Michael R. Hines wrote:
> To be more specific, here's what I did:
> 
> 1. apply kernel module patch - re-insert module
> 1. QEMU does: ibv_reg_mr(........IBV_ACCESS_GIFT | IBV_ACCESS_REMOTE_READ)
> 2. Start the RDMA migration
> 3. Migration completes without any errors
> 
> This test does *not* work with a cgroup swap limit, however. The
> process gets killed. (Both with and without GIFT)
> 
> - Michael

Try to attach a debugger and see where it is when it gets killed?

> On 04/05/2013 04:43 PM, Roland Dreier wrote:
> >On Fri, Apr 5, 2013 at 1:17 PM, Michael R. Hines
> ><mrhines@linux.vnet.ibm.com> wrote:
> >>I also removed the IBV_*_WRITE flags on the sender-side and activated
> >>cgroups with the "memory.memsw.limit_in_bytes" activated and the migration
> >>with RDMA also succeeded without any problems (both with *and* without GIFT
> >>also worked).
> >Not sure I'm interpreting this correctly.  Are you saying that things
> >worked without actually setting the GIFT flag?   In which case why are
> >we adding this flag?
> >
> >  - R.
> >
> 
