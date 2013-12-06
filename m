Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151Ab3LFUbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:31:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161116Ab3LFUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:31:00 -0500
Date: Fri, 06 Dec 2013 15:30:58 -0500 (EST)
Message-Id: <20131206.153058.1741013299538900621.davem@davemloft.net>
To: avagin@openvz.org
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com
Subject: Re: [PATCH 2/2] virtio: delete napi structures from netdev before
 releasing memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386254181-17257-3-git-send-email-avagin@openvz.org>
References: <1386254181-17257-1-git-send-email-avagin@openvz.org>
	<1386254181-17257-3-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 12:31:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Thu,  5 Dec 2013 18:36:21 +0400

> free_netdev calls netif_napi_del too, but it's too late, because napi
> structures are placed on vi->rq. netif_napi_add() is called from
> virtnet_alloc_queues.
 ...
> Fixes: 986a4f4d452d (virtio_net: multiqueue support)
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied and queued up for -stable, thanks.
