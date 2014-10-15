Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJOUrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:47:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54171 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaJOUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:47:30 -0400
Date: Wed, 15 Oct 2014 16:47:27 -0400 (EDT)
Message-Id: <20141015.164727.298073723527552510.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: [PATCH] virtio_net: fix use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413378878-28118-1-git-send-email-mst@redhat.com>
References: <1413378878-28118-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 13:47:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 15 Oct 2014 16:23:28 +0300

> You used __netif_subqueue_stopped but that seems to use
> a slightly more expensive test_bit internally.

More expensive in what sense?  It should be roughly the same
as "x & y" sans the volatile.

Anyways I'm ambivalent and I want to see this bug fixes, so I'll
apply your patch.

Thanks!
