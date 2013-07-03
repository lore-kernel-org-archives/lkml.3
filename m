Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab3GCX7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:59:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39604 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3GCX7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:59:46 -0400
Date: Wed, 03 Jul 2013 16:59:45 -0700 (PDT)
Message-Id: <20130703.165945.721617006723749470.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sasha.levin@oracle.com
Subject: Re: [PATCH net] virtio-net: fix the race between channels setting
 and refill
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372853752-41889-1-git-send-email-jasowang@redhat.com>
References: <1372853752-41889-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed,  3 Jul 2013 20:15:52 +0800

> Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx queues
> which are being used) tries to refill on demand when changing the number of
> channels by call try_refill_recv() directly, this may race:
> 
> - the refill work who may do the refill in the same time
> - the try_refill_recv() called in bh since napi was not disabled
> 
> Which may led guest complain during setting channels:
> 
> virtio_net virtio0: input.1:id 0 is not a head!
> 
> Solve this issue by scheduling a refill work which can guarantee the
> serialization of refill.
> 
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Michael, please review.

Thanks.
