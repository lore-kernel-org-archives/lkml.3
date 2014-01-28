Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaA1RIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:08:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbaA1RIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:08:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
cc: dhowells@redhat.com, linux-afs@lists.infradead.org,
        Tim Smith <tim@electronghost.co.uk>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] AF_RXRPC fixes
Date: Tue, 28 Jan 2014 17:07:36 +0000
Message-ID: <8672.1390928856@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some small AF_RXRPC fixes.

 (1) Fix a place where a spinlock is taken conditionally but is released
     unconditionally.

 (2) Fix a double-free that happens when cleaning up on a checksum error.

 (3) Fix handling of CHECKSUM_PARTIAL whilst delivering messages to userspace.

David
---
The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-20140126

for you to fetch changes up to 1ea427359dde1573815e19c411ce08fdf0c42cfe:

  af_rxrpc: Handle frames delivered from another VM (2014-01-26 11:45:04 +0000)

----------------------------------------------------------------
RxRPC fixes

----------------------------------------------------------------
Alexey Khoroshilov (1):
      RxRPC: do not unlock unheld spinlock in rxrpc_connect_exclusive()

Tim Smith (2):
      af_rxrpc: Avoid setting up double-free on checksum error
      af_rxrpc: Handle frames delivered from another VM

 net/rxrpc/ar-connection.c | 2 ++
 net/rxrpc/ar-recvmsg.c    | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)
