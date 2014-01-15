Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaAOXXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaAOXXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:23:51 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] reciprocal_divide updates
Date: Thu, 16 Jan 2014 00:23:46 +0100
Message-Id: <1389828228-30312-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set is on top of Eric's BPF fix, that is:

   http://patchwork.ozlabs.org/patch/311163/

Daniel Borkmann (1):
  random32: add prandom_u32_lt_N and convert "misuses" of reciprocal_divide

Hannes Frederic Sowa (1):
  reciprocal_divide: correction/update of the algorithm

 drivers/net/bonding/bond_main.c     | 16 +++++++-------
 drivers/net/bonding/bond_netlink.c  |  4 ----
 drivers/net/bonding/bond_options.c  |  9 +++-----
 drivers/net/bonding/bond_sysfs.c    |  5 -----
 drivers/net/bonding/bonding.h       |  3 +++
 drivers/net/team/team_mode_random.c |  8 +------
 include/linux/flex_array.h          |  3 ++-
 include/linux/random.h              | 19 ++++++++++++++++-
 include/linux/reciprocal_div.h      | 42 ++++++++++++++++++++++---------------
 include/linux/slab_def.h            |  4 +++-
 include/net/codel.h                 |  4 +---
 include/net/red.h                   |  3 ++-
 lib/flex_array.c                    |  3 ++-
 lib/reciprocal_div.c                | 28 +++++++++++++++++++++----
 net/packet/af_packet.c              |  5 ++---
 net/sched/sch_choke.c               |  9 +-------
 net/sched/sch_netem.c               |  4 +++-
 17 files changed, 99 insertions(+), 70 deletions(-)

-- 
1.8.3.1

