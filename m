Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3KNVGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:06:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3KNVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:06:37 -0500
Date: Thu, 14 Nov 2013 16:06:30 -0500 (EST)
Message-Id: <20131114.160630.604524891761475222.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        stefanha@redhat.com, gregory.v.rose@intel.com
Subject: Re: [PATCH net V2 1/2] tuntap: limit head length of skb allocated
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384322440-29038-1-git-send-email-jasowang@redhat.com>
References: <1384322440-29038-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 14 Nov 2013 13:06:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 13 Nov 2013 14:00:39 +0800

> We currently use hdr_len as a hint of head length which is advertised by
> guest. But when guest advertise a very big value, it can lead to an 64K+
> allocating of kmalloc() which has a very high possibility of failure when host
> memory is fragmented or under heavy stress. The huge hdr_len also reduce the
> effect of zerocopy or even disable if a gso skb is linearized in guest.
> 
> To solves those issues, this patch introduces an upper limit (PAGE_SIZE) of the
> head, which guarantees an order 0 allocation each time.
> 
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable.
