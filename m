Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936163Ab3DIUIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:08:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935712Ab3DIUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:08:54 -0400
Date: Tue, 9 Apr 2013 22:09:44 +0300
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
Message-ID: <20130409190943.GC8212@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3948.40205@linux.vnet.ibm.com>
 <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 02:03:33PM -0700, Roland Dreier wrote:
> On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
> <mrhines@linux.vnet.ibm.com> wrote:
> > Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
> > (i.e. trying to register RDMA memory while using a cgroup swap limit cause
> > the process get killed).
> >
> > But the GIFT flag patch works (my understanding is that GIFT flag allows the
> > adapter to transmit stale memory information, it does not have anything to
> > do with cgroups specifically).
> 
> The point of the GIFT patch is to avoid triggering copy-on-write so
> that memory doesn't blow up during migration.  If that doesn't work
> then there's no point to the patch.
> 
>  - R.

Absolutely. Checking whether an OOM gets triggered looks like a heavy
handed approach to testing the feature though.
It's relevant, but there could be many other reasons for it to trigger.
See Documentation/cgroups/memory.txt section "Troubleshooting".

It's easier to just check whether this patch reduces the memory consumption,
that's the point really.

-- 
MST
