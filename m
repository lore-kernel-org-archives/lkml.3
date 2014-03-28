Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaC1UJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:09:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40440 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaC1UJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:09:43 -0400
Date: Fri, 28 Mar 2014 16:09:40 -0400 (EDT)
Message-Id: <20140328.160940.1707102420095481862.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: [PATCHv2 net] vhost: fix total length when packets are too
 short
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140327100026.GA30715@redhat.com>
References: <20140327100026.GA30715@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Mar 2014 13:09:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 27 Mar 2014 12:00:26 +0200

> When mergeable buffers are disabled, and the
> incoming packet is too large for the rx buffer,
> get_rx_bufs returns success.
> 
> This was intentional in order for make recvmsg
> truncate the packet and then handle_rx would
> detect err != sock_len and drop it.
> 
> Unfortunately we pass the original sock_len to
> recvmsg - which means we use parts of iov not fully
> validated.
> 
> Fix this up by detecting this overrun and doing packet drop
> immediately.
> 
> CVE-2014-0077
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Changes from v1:
> 	Fix CVE# in the commit log.
> 	Patch is unchanged.
> 
> Note: this is needed for -stable.

Applied and queued up for -stable.

> I wonder if this can still make the release.

I will try but no promises.
