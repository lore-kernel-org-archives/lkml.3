Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3JAFDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 01:03:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42553 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3JAFDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 01:03:34 -0400
Date: Mon, 30 Sep 2013 22:10:40 -0700 (PDT)
Message-Id: <20130930.221040.543720988967287293.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH V2] virtio-net: switch to use XPS to choose txq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380526637-35524-1-git-send-email-jasowang@redhat.com>
References: <1380526637-35524-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 30 Sep 2013 22:03:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9153whG014846

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 30 Sep 2013 15:37:17 +0800

> We used to use a percpu structure vq_index to record the cpu to queue
> mapping, this is suboptimal since it duplicates the work of XPS and
> loses all other XPS functionality such as allowing use to configure
> their own transmission steering strategy.
> 
> So this patch switches to use XPS and suggest a default mapping when
> the number of cpus is equal to the number of queues. With XPS support,
> there's no need for keeping per-cpu vq_index and .ndo_select_queue(),
> so they were removed also.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - use cpumask_of() instead of allocate dynamically

This generates build warnings:

drivers/net/virtio_net.c: In function ¡virtnet_set_affinity¢:
drivers/net/virtio_net.c:1093:3: warning: passing argument 2 of ¡netif_set_xps_queue¢ discards ¡const¢ qualifier from pointer target type [enabled by default]
In file included from drivers/net/virtio_net.c:20:0:
include/linux/netdevice.h:2275:5: note: expected ¡struct cpumask *¢ but argument is of type ¡const struct cpumask *¢
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
