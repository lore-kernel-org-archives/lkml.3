Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBMXsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:48:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51569 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBMXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:48:28 -0500
Date: Thu, 13 Feb 2014 18:48:25 -0500 (EST)
Message-Id: <20140213.184825.32399543190618715.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: [PATCH net v2] vhost: fix a theoretical race in device cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392284540-2031-1-git-send-email-mst@redhat.com>
References: <1392284540-2031-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 15:48:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 13 Feb 2014 11:45:11 +0200

> vhost_zerocopy_callback accesses VQ right after it drops a ubuf
> reference.  In theory, this could race with device removal which waits
> on the ubuf kref, and crash on use after free.
> 
> Do all accesses within rcu read side critical section, and synchronize
> on release.
> 
> Since callbacks are always invoked from bh, synchronize_rcu_bh seems
> enough and will help release complete a bit faster.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> This is was previously posted as part of patch
> series, but it's an independent fix really.
> Theoretical race so not needed for stable I think.

Ok, no -stable, applied.
