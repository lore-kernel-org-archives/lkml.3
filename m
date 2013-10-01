Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3JACBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 22:01:43 -0400
Received: from ozlabs.org ([203.10.76.45]:46636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab3JACBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 22:01:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH V2] virtio-net: switch to use XPS to choose txq
In-Reply-To: <20130930090402.GB20291@redhat.com>
References: <1380526637-35524-1-git-send-email-jasowang@redhat.com> <20130930090402.GB20291@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 01 Oct 2013 11:24:08 +0930
Message-ID: <87eh8521tr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Mon, Sep 30, 2013 at 03:37:17PM +0800, Jason Wang wrote:
>> We used to use a percpu structure vq_index to record the cpu to queue
>> mapping, this is suboptimal since it duplicates the work of XPS and
>> loses all other XPS functionality such as allowing use to configure
>> their own transmission steering strategy.
>> 
>> So this patch switches to use XPS and suggest a default mapping when
>> the number of cpus is equal to the number of queues. With XPS support,
>> there's no need for keeping per-cpu vq_index and .ndo_select_queue(),
>> so they were removed also.
>> 
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Dave, please apply.

Cheers,
Rusty.
