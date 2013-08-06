Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3HFJ4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab3HFJ4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:56:22 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next 0/6] Reduce code duplication of zerocopy of tun and macvtap
Date: Tue,  6 Aug 2013 17:45:02 +0800
Message-Id: <1375782308-10565-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series tries to reduce the code duplication of zerocopy of tun and macvtap
by:

- Move common helpers iov_pages() and zerocopy_sg_from_iovec() to net/core
- Use exist helpers instead of open coding the new one

With this seires, we can do further optimizations on top.

Please review.

Jason Wang (6):
  net: move iov_pages() to net/core/iovec.c
  net: move zerocopy_sg_from_iovec() to net/core/datagram.c
  net: use skb_fill_page_desc() in zerocopy_sg_from_iovec()
  net: remove the useless comment in zerocopy_sg_from_iovec()
  net: use release_pages() in zerocopy_sg_from_iovec()
  net: use skb_copy_datagram_from_iovec() in zerocopy_sg_from_iovec()

 drivers/net/macvtap.c  |  103 ------------------------------------------------
 drivers/net/tun.c      |  103 ------------------------------------------------
 include/linux/skbuff.h |    4 ++
 include/linux/socket.h |    2 +
 net/core/datagram.c    |   72 +++++++++++++++++++++++++++++++++
 net/core/iovec.c       |   24 +++++++++++
 6 files changed, 102 insertions(+), 206 deletions(-)

