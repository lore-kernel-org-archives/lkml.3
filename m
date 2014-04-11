Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaDKDFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:05:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbaDKDFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:05:03 -0400
Message-ID: <1397185491.6230.4.camel@localhost>
Subject: Re: [PATCH RFC V2 4/4] tools: virtio: add a top-like utility for
 displaying vhost satistics
From: Jason Wang <jasowang@redhat.com>
To: Fam Zheng <famz@redhat.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 11 Apr 2014 11:04:51 +0800
In-Reply-To: <20140410092702.GJ22890@T430.nay.redhat.com>
References: <1395394913-19548-1-git-send-email-jasowang@redhat.com>
	 <1395394913-19548-5-git-send-email-jasowang@redhat.com>
	 <20140410092702.GJ22890@T430.nay.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 17:27 +0800, Fam Zheng wrote:
> On Fri, 03/21 17:41, Jason Wang wrote:
> > This patch adds simple python to display vhost satistics of vhost, the codes
> > were based on kvm_stat script from qemu. As work function has been recored,
> > filters could be used to distinguish which kinds of work are being executed or
> > queued:
> > 
> > vhost statistics
> > 
> >  vhost_virtio_update_used_idx               1215215       0
> >  vhost_virtio_get_vq_desc                   1215215       0
> >  vhost_work_queue_wakeup                     986808       0
> >  vhost_virtio_signal                         811601       0
> >  vhost_net_tx                                611457       0
> >  vhost_net_rx                                603758       0
> >  vhost_net_tx(datacopy)                      601903       0
> >  vhost_work_queue_wakeup(rx_net)             565081       0
> >  vhost_virtio_signal(rx)                     461603       0
> >  vhost_work_queue_wakeup(tx_kick)            421718       0
> >  vhost_virtio_update_avail_event             417346       0
> >  vhost_virtio_signal(tx)                     349998       0
> >  vhost_work_queue_coalesce                    39384       0
> >  vhost_work_queue_coalesce(rx_net)            38677       0
> >  vhost_net_tx(zerocopy)                        9554       0
> >  vhost_work_queue_coalesce(tx_kick)             707       0
> >  vhost_work_queue_wakeup(rx_kick)                 9       0
> > 
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  tools/virtio/vhost_stat | 375 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 375 insertions(+)
> >  create mode 100755 tools/virtio/vhost_stat
> > 
> > diff --git a/tools/virtio/vhost_stat b/tools/virtio/vhost_stat
> > new file mode 100755
> > index 0000000..398fd4a
> > --- /dev/null
> > +++ b/tools/virtio/vhost_stat
> > @@ -0,0 +1,375 @@
> > +#!/usr/bin/python
> > +#
> > +# top-like utility for displaying vhost statistics
> > +#
> > +# Copyright 2012 Red Hat, Inc.
> 
> Should it be 2014?
> 
> Fam
> 
> <snip>

Yes it should, thanks for pointing this out.

