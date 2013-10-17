Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614Ab3JQT4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:56:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46657 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3JQT4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:56:00 -0400
Date: Thu, 17 Oct 2013 15:55:58 -0400 (EDT)
Message-Id: <20131017.155558.1300032440298974117.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2 2/2] virtio-net: refill only when device is up
 during setting queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381807139-3450-2-git-send-email-jasowang@redhat.com>
References: <1381807139-3450-1-git-send-email-jasowang@redhat.com>
	<1381807139-3450-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 12:56:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 15 Oct 2013 11:18:59 +0800

> We used to schedule the refill work unconditionally after changing the
> number of queues. This may lead an issue if the device is not
> up. Since we only try to cancel the work in ndo_stop(), this may cause
> the refill work still work after removing the device. Fix this by only
> schedule the work when device is up.
> 
> The bug were introduce by commit 9b9cd8024a2882e896c65222aa421d461354e3f2.
> (virtio-net: fix the race between channels setting and refill)
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable, thanks Jason.
