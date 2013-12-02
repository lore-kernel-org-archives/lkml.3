Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3LBB1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:27:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45364 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3LBB1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:27:54 -0500
Date: Sun, 01 Dec 2013 20:27:52 -0500 (EST)
Message-Id: <20131201.202752.1283570881734672398.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mwdalton@google.com,
        edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] virtio_net: fix error handling for mergeable
 buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385638044-27467-1-git-send-email-mst@redhat.com>
References: <1385638044-27467-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 01 Dec 2013 17:27:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 28 Nov 2013 13:30:55 +0200

> Eric Dumazet noticed that if we encounter an error
> when processing a mergeable buffer, we don't
> dequeue all of the buffers from this packet,
> the result is almost sure to be loss of networking.
> 
> Jason Wang noticed that we also leak a page and that we don't decrement
> the rq buf count, so we won't repost buffers (a resource leak).
> 
> Fix both issues.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael Dalton <mwdalton@google.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
