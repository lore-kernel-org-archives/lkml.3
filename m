Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaLBKIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:08:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaLBKIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:08:16 -0500
Date: Tue, 2 Dec 2014 12:08:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Jason Wang'" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pagupta@redhat.com" <pagupta@redhat.com>
Subject: Re: [PATCH RFC v4 net-next 0/5] virtio_net: enabling tx interrupts
Message-ID: <20141202100806.GA8056@redhat.com>
References: <1417429028-11971-1-git-send-email-jasowang@redhat.com>
 <20141201104223.GB16108@redhat.com>
 <1417490120.4405.2@smtp.corp.redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CA007CC@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CA007CC@AcuExch.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:00:06AM +0000, David Laight wrote:
> From: Jason Wang
> > > On Mon, Dec 01, 2014 at 06:17:03PM +0800, Jason Wang wrote:
> > >>  Hello:
> > >>
> > >>  We used to orphan packets before transmission for virtio-net. This
> > >> breaks
> > >>  socket accounting and can lead serveral functions won't work, e.g:
> > >>
> > >>  - Byte Queue Limit depends on tx completion nofication to work.
> > >>  - Packet Generator depends on tx completion nofication for the last
> > >>    transmitted packet to complete.
> > >>  - TCP Small Queue depends on proper accounting of sk_wmem_alloc to
> > >> work.
> > >>
> > >>  This series tries to solve the issue by enabling tx interrupts. To
> > >> minize
> > >>  the performance impacts of this, several optimizations were used:
> > >>
> > >>  - In guest side, virtqueue_enable_cb_delayed() was used to delay the tx
> > >>    interrupt untile 3/4 pending packets were sent.
> 
> Doesn't that give problems for intermittent transmits?
> 
> ...
> 
> 	David
> 

No because it has not effect in that case.

-- 
MST
