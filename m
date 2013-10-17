Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590Ab3JQTzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:55:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46646 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab3JQTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:55:48 -0400
Date: Thu, 17 Oct 2013 15:55:45 -0400 (EDT)
Message-Id: <20131017.155545.3271252320146665.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com
Subject: Re: [PATCH net V2 1/2] virtio-net: don't respond to cpu hotplug
 notifier if we're not ready
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
References: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 12:55:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 15 Oct 2013 11:18:58 +0800

> We're trying to re-configure the affinity unconditionally in cpu hotplug
> callback. This may lead the issue during resuming from s3/s4 since
> 
> - virt queues haven't been allocated at that time.
> - it's unnecessary since thaw method will re-configure the affinity.
> 
> Fix this issue by checking the config_enable and do nothing is we're not ready.
> 
> The bug were introduced by commit 8de4b2f3ae90c8fc0f17eeaab87d5a951b66ee17
> (virtio-net: reset virtqueue affinity when doing cpu hotplug).
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable.
