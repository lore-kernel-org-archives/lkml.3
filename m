Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3KSWAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:00:19 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:53994 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3KSWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:00:17 -0500
Message-ID: <1384898411.8604.127.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Date: Tue, 19 Nov 2013 14:00:11 -0800
In-Reply-To: <20131119215312.GE15004@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
	 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20131119204909.GA15004@redhat.com>
	 <1384896996.8604.120.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20131119215312.GE15004@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 23:53 +0200, Michael S. Tsirkin wrote:

> Which NIC? Virtio? Prior to 2613af0ed18a11d5c566a81f9a6510b73180660a
> it didn't drop packets received from host as far as I can tell.
> virtio is more like a pipe than a real NIC in this respect.

Prior/after to this patch, you were not posting buffers, so if packets
were received on a physical NIC, you were dropping the packets anyway.

It makes no difference at all, adding a cushion might make you feel
better, but its really not worth it.

Under memory stress, it makes better sense to drop a super big GRO
packet (The one needing frag_list extension ...)

It gives a better signal to the sender to reduce its pressure, and gives
opportunity to free more of your memory.



