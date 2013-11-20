Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3KTJDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:03:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3KTJDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:03:19 -0500
Date: Wed, 20 Nov 2013 11:06:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
Message-ID: <20131120090627.GE19341@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119204909.GA15004@redhat.com>
 <CANJ5vPKmP6rFsBgMGFM8DcuGww7B9PxJMSBkUMHNZOa7LJOA2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANJ5vPKmP6rFsBgMGFM8DcuGww7B9PxJMSBkUMHNZOa7LJOA2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 01:38:16PM -0800, Michael Dalton wrote:
> Great catch Jason. I agree this now raises the larger issue of how to
> handle a memory alloc failure in the middle of receive. As Eric mentioned,
> we can drop the packet and free the remaining (num_buf) frags.
> 
> Michael, perhaps I'm missing something, but why would you prefer
> pre-allocating buffers in this case? If the guest kernel is OOM'ing,
> dropping packets should provide backpressure.
> 
> Also, we could just as easily fail the initial skb alloc in page_to_skb,
> and I think that case also needs to be handled now in the same fashion as
> a memory allocation failure in receive_mergeable.
> 
> Best,
> 
> Mike

Yes I missed this last night. Thanks a lot Eric and Michael for pointing
this out.
