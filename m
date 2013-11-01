Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3KAC3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:29:24 -0400
Received: from ozlabs.org ([203.10.76.45]:60302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3KAC3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:29:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com,
        mwdalton@google.com, virtualization@lists.linux-foundation.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net-next 2/2] virtio-net: coalesce rx frags when possible during rx
In-Reply-To: <1383215313-23651-2-git-send-email-jasowang@redhat.com>
References: <1383215313-23651-1-git-send-email-jasowang@redhat.com> <1383215313-23651-2-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 01 Nov 2013 12:43:46 +1030
Message-ID: <87iowcc1id.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> Commit 2613af0ed18a11d5c566a81f9a6510b73180660a (virtio_net: migrate mergeable
> rx buffers to page frag allocators) try to increase the payload/truesize for
> MTU-sized traffic. But this will introduce the extra overhead for GSO packets
> received because of the frag list. This commit tries to reduce this issue by
> coalesce the possible rx frags when possible during rx. Test result shows the
> about 15% improvement on full size GSO packet receiving (and even better than
> commit 2613af0ed18a11d5c566a81f9a6510b73180660a).

I don't know about the other users of skb_add_rx_frag, but should
this coalesce-if-possible code be built into that?

Thanks,
Rusty.
