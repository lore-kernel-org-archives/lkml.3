Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3KTQO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:14:28 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61145 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3KTQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:14:23 -0500
Message-ID: <1384964061.8604.151.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Date: Wed, 20 Nov 2013 08:14:21 -0800
In-Reply-To: <20131120160625.GA21188@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
	 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20131119204909.GA15004@redhat.com>
	 <1384896996.8604.120.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20131119215312.GE15004@redhat.com>
	 <1384898411.8604.127.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20131120085835.GB19341@redhat.com>
	 <1384960593.8604.147.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20131120160625.GA21188@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 18:06 +0200, Michael S. Tsirkin wrote:

> Hmm some kind of disconnect here.
> I got you rmanagement about bufferbloat.
> 
> What I am saying is that maybe we should drop packets more
> aggressively: when we drop one packet of a flow, why not
> drop everything that's queued and is for the same flow?

I really hope your TCP flows use SACK ;)

Please read the rfc 2018 introduction for details.

If a packet is dropped, it doesn't mean following packets _have_ to be
dropped.


