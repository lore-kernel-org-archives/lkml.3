Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3GIFRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3GIFRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:17:17 -0400
Date: Tue, 9 Jul 2013 08:18:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
        Amos Kong <akong@redhat.com>, Dave Jones <davej@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
Message-ID: <20130709051824.GA3234@redhat.com>
References: <20130708101259.GA16074@redhat.com>
 <871u78eavc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u78eavc.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 11:46:23AM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > For small packets we can simplify xmit processing
> > by linearizing buffers with the header:
> > most packets seem to have enough head room
> > we can use for this purpose.
> > Since existing hypervisors require that header
> > is the first s/g element, we need a feature bit
> > for this.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >
> > Note: this needs to be applied on top of patch
> > defining VIRTIO_F_ANY_LAYOUT - bit to be
> > selected by Rusty.
> >
> > The following patch should work for any definition of
> > VIRTIO_F_ANY_LAYOUT - I used bit 31 for testing.
> > Rusty, could you please pick a valid bit for VIRTIO_F_ANY_LAYOUT
> > and squeeze this patch into 3.11?
> 
> Sorry, it's too late.
> 
> First, I've been a bit lax in sending patches via DaveM, and this is
> definitely his territory (ie. more net than virtio).

Let's do this: I'll send a patch series, you ack and we see
what happens?

> Secondly, it needs baking and testing time.
> 
> Cheers,
> Rusty.

I did some testing on this.  But proper testing just isn't happening out
of tree.

-- 
MST
