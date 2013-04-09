Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197Ab3DIURq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936020Ab3DIURo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:17:44 -0400
Date: Tue, 9 Apr 2013 22:12:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Message-ID: <20130409191218.GD8212@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 01:43:49PM -0700, Roland Dreier wrote:
> On Fri, Apr 5, 2013 at 1:17 PM, Michael R. Hines
> <mrhines@linux.vnet.ibm.com> wrote:
> > I also removed the IBV_*_WRITE flags on the sender-side and activated
> > cgroups with the "memory.memsw.limit_in_bytes" activated and the migration
> > with RDMA also succeeded without any problems (both with *and* without GIFT
> > also worked).
> 
> Not sure I'm interpreting this correctly.  Are you saying that things
> worked without actually setting the GIFT flag?   In which case why are
> we adding this flag?
> 
>  - R.

We are adding the flag to reduce memory when there's lots of COW pages.
There's no guarantee there will be COW pages so I expect things to work
both with and without breaking COW, just using much more memory when we
break COW.

-- 
MST
