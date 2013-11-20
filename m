Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3KTRAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:00:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab3KTRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:00:43 -0500
Date: Wed, 20 Nov 2013 19:03:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
Message-ID: <20131120170333.GA21972@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119204909.GA15004@redhat.com>
 <1384896996.8604.120.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119215312.GE15004@redhat.com>
 <1384898411.8604.127.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131120085835.GB19341@redhat.com>
 <1384960593.8604.147.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131120160625.GA21188@redhat.com>
 <1384964061.8604.151.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384964061.8604.151.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:14:21AM -0800, Eric Dumazet wrote:
> On Wed, 2013-11-20 at 18:06 +0200, Michael S. Tsirkin wrote:
> 
> > Hmm some kind of disconnect here.
> > I got you rmanagement about bufferbloat.
> > 
> > What I am saying is that maybe we should drop packets more
> > aggressively: when we drop one packet of a flow, why not
> > drop everything that's queued and is for the same flow?
> 
> I really hope your TCP flows use SACK ;)
> 
> Please read the rfc 2018 introduction for details.
> 
> If a packet is dropped, it doesn't mean following packets _have_ to be
> dropped.


Got it, thanks.
