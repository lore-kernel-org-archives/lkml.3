Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3KSVik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:38:40 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62442 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3KSVih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131119204909.GA15004@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com> <20131119204909.GA15004@redhat.com>
From: Michael Dalton <mwdalton@google.com>
Date: Tue, 19 Nov 2013 13:38:16 -0800
Message-ID: <CANJ5vPKmP6rFsBgMGFM8DcuGww7B9PxJMSBkUMHNZOa7LJOA2g@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great catch Jason. I agree this now raises the larger issue of how to
handle a memory alloc failure in the middle of receive. As Eric mentioned,
we can drop the packet and free the remaining (num_buf) frags.

Michael, perhaps I'm missing something, but why would you prefer
pre-allocating buffers in this case? If the guest kernel is OOM'ing,
dropping packets should provide backpressure.

Also, we could just as easily fail the initial skb alloc in page_to_skb,
and I think that case also needs to be handled now in the same fashion as
a memory allocation failure in receive_mergeable.

Best,

Mike
