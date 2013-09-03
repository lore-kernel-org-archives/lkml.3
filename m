Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3ICEtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 00:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3ICEs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 00:48:59 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, dan.duval@oracle.com,
        akpm@linux-foundation.org, rgb@redhat.com, oleg@redhat.com,
        chuck.anderson@oracle.com
Subject: [PATCH 0/2] audit: fix soft lockup
Date: Tue,  3 Sep 2013 00:48:53 -0400
Message-Id: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second patch fixes a softlockup which is fully described and now is
100% reproducible with simple steps. The first patch fixes a bug I found
while working on the second patch.

Chuck Anderson just posted a different solution for the same problem.
I was about to post this solution when he posted his version, so I'm
posting it anyway.

Luiz capitulino (2):
  audit: flush_hold_queue(): don't drop queued SKBs
  audit: kaudit_send_skb(): make non-blocking call to netlink_unicast()

 kernel/audit.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

-- 
1.8.1.4
