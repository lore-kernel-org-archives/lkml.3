Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3KFDWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:22:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3KFDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:22:06 -0500
Date: Tue, 05 Nov 2013 22:22:03 -0500 (EST)
Message-Id: <20131105.222203.740870236265138632.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] virtio-net: switch to use XPS to
 choose txq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383646785-10446-1-git-send-email-jasowang@redhat.com>
References: <1383646785-10446-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Nov 2013 19:22:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue,  5 Nov 2013 18:19:45 +0800

> We used to use a percpu structure vq_index to record the cpu to queue
> mapping, this is suboptimal since it duplicates the work of XPS and
> loses all other XPS functionality such as allowing user to configure
> their own transmission steering strategy.
> 
> So this patch switches to use XPS and suggest a default mapping when
> the number of cpus is equal to the number of queues. With XPS support,
> there's no need for keeping per-cpu vq_index and .ndo_select_queue(),
> so they were removed also.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Resend since the previous complie warning disappears after commit
> 3573540cafa4296dd60f8be02f2aecaa31047525
> (netif_set_xps_queue: make cpu mask const).

Yep, looks great, applied.  Thanks Jason!
