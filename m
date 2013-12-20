Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3LTXLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:11:13 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:65524 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3LTXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:11:11 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/3] null_blk: documentation, defaults and mapping
Date: Sat, 21 Dec 2013 00:10:58 +0100
Message-Id: <1387581061-25987-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These three patches cover:

* Incorporated the feedback from Randy Dunlap into documentation.
  Can be merged with the previous documentation commit (6824518).
* Set use_per_node_hctx to false per default to save resources.
* Allow submit_queues and use_per_node_hctx to be used simultanesly.
  If the submit_queues is a multiple of nr_online_nodes, its trivial. Simply map
  them to the nodes. For example: 8 submit queues are mapped as node0[0,1],
  node1[2,3], ...
  If uneven, we are left with an uneven number of submit_queues that must be
  mapped. These are mapped toward the first node and onward. E.g. 5
  submit queues mapped onto 4 nodes are mapped as node0[0,1], node1[2], ...

Matias Bjørling (3):
  null_blk: corrections to documentation
  null_blk: set use_per_node_hctx param to false
  null_blk: support submit_queues on use_per_node_hctx

 Documentation/block/null_blk.txt | 27 +++++++++++++------------
 drivers/block/null_blk.c         | 43 ++++++++++++++++++++++++++++++++++------
 2 files changed, 51 insertions(+), 19 deletions(-)

-- 
1.8.3.2

