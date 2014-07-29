Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaG2Lln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:41:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:35921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaG2Llk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:41:40 -0400
From: Thomas Graf <tgraf@suug.ch>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org
Subject: [PATCH 0/2 net-next] Lockless netlink_lookup() with new concurrent hash table
Date: Tue, 29 Jul 2014 13:41:31 +0200
Message-Id: <cover.1406633945.git.tgraf@suug.ch>
X-Mailer: git-send-email 1.9.3
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@suug.ch> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netlink sockets are maintained in a hash table to allow efficient lookup
via the port ID for unicast messages. However, lookups currently require
a read lock to be taken. This series adds a new generic, resizable,
scalable, concurrent hash table based on the paper referenced in the first
patch. It then makes use of the new data type to implement lockless
netlink_lookup().

Against net-next since the initial user of the new hash table is in net/

Thomas Graf (2):
  lib: Resizable, Scalable, Concurrent Hash Table
  netlink: Convert netlink_lookup() to use RCU protected hash table

 include/linux/rhashtable.h | 208 ++++++++++++
 lib/Kconfig.debug          |   8 +
 lib/Makefile               |   2 +-
 lib/rhashtable.c           | 783 +++++++++++++++++++++++++++++++++++++++++++++
 net/netlink/af_netlink.c   | 285 +++++++----------
 net/netlink/af_netlink.h   |  18 +-
 net/netlink/diag.c         |  11 +-
 7 files changed, 1119 insertions(+), 196 deletions(-)
 create mode 100644 include/linux/rhashtable.h
 create mode 100644 lib/rhashtable.c

-- 
1.9.3

