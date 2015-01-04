Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbbADLgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 06:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbbADLgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 06:36:19 -0500
Date: Sun, 4 Jan 2015 13:36:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Sharing MSIX irq for tx/rx queue pairs
Message-ID: <20150104113613.GC4336@redhat.com>
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
 <20141228075226.GA25704@redhat.com>
 <54A8FBF9.7000105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A8FBF9.7000105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 04:38:17PM +0800, Jason Wang wrote:
> 
> On 12/28/2014 03:52 PM, Michael S. Tsirkin wrote:
> > On Fri, Dec 26, 2014 at 10:53:42AM +0800, Jason Wang wrote:
> >> Hi all:
> >>
> >> This series try to share MSIX irq for each tx/rx queue pair. This is
> >> done through:
> >>
> >> - introducing virtio pci channel which are group of virtqueues that
> >>   sharing a single MSIX irq (Patch 1)
> >> - expose channel setting to virtio core api (Patch 2)
> >> - try to use channel setting in virtio-net (Patch 3)
> >>
> >> For the transport that does not support channel, channel paramters
> >> were simply ignored. For devices that does not use channel, it can
> >> simply pass NULL or zero to virito core.
> >>
> >> With the patch, 1 MSIX irq were saved for each TX/RX queue pair.
> >>
> >> Please review.
> > How does this sharing affect performance?
> >
> 
> Patch 3 only checks more_used() for tx ring which in fact reduces the
> effect of event index and may introduce more tx interrupts. After fixing
> this issue, tested with 1 vcpu and 1 queue. No obvious changes in
> performance were noticed.
> 
> Thanks

Is this with or without MQ?
With MQ, it seems easy to believe as interrupts are
distributed between CPUs.

Without MQ, it should be possible to create UDP workloads where
processing incoming and outgoing interrupts
on separate CPUs is a win.

-- 
MST
