Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaKVE3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 23:29:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34225 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKVE27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 23:28:59 -0500
Date: Sat, 22 Nov 2014 04:28:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141122042856.GZ7996@ZenIV.linux.org.uk>
References: <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <20141120.182339.972861702759954603.davem@davemloft.net>
 <20141121.122615.1091044030302005883.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121.122615.1091044030302005883.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	OK, here's the next bunch.  Sorry about the delay, iov_iter.c stuff
took most of the day (and it's not included in this pile).  Please, review.
Al Viro (17):
      new helper: skb_copy_and_csum_datagram_msg()
      new helper: memcpy_from_msg()
      switch ipxrtr_route_packet() from iovec to msghdr
      new helper: memcpy_to_msg()
      switch drivers/net/tun.c to ->read_iter()
      switch macvtap to ->read_iter()
      new helpers: skb_copy_datagram_from_iter() and zerocopy_sg_from_iter()
      {macvtap,tun}_get_user(): switch to iov_iter
      kill zerocopy_sg_from_iovec()
      switch AF_PACKET and AF_UNIX to skb_copy_datagram_from_iter()
      switch sctp_user_addto_chunk() and sctp_datamsg_from_user() to passing iov_iter
      tipc_sendmsg(): pass msghdr instead of its ->msg_iov
      tipc_msg_build(): pass msghdr instead of its ->msg_iov
      vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr
      [atm] switch vcc_sendmsg() to copy_from_iter()
      rds: switch ->inc_copy_to_user() to passing iov_iter
      rds: switch rds_message_copy_from_user() to iov_iter

Patches themselves are in followups...
