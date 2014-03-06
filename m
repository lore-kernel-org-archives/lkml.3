Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaCFVyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:54:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17698 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaCFVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:54:24 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: fubar@us.ibm.com, vfalico@redhat.com, andy@greyhouse.net
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikolay@redhat.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2] bonding: correctly handle out of range parameters for lp_interval
Date: Thu,  6 Mar 2014 16:53:11 -0500
Message-Id: <1394142791-11142-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We didn't correctly check cases where the value for lp_interval is not
within the legal range due to a missing table terminator.

This would let userspace trigger a kernel panic by specifying a value out
of range:

	echo -1 > /sys/devices/virtual/net/bond0/bonding/lp_interval

Introduced by commit 4325b374f84 ("bonding: convert lp_interval to use
the new option API").

Acked-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/net/bonding/bond_options.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 23f3655..4d35cdc 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -124,6 +124,7 @@ static struct bond_opt_value bond_resend_igmp_tbl[] = {
 static struct bond_opt_value bond_lp_interval_tbl[] = {
 	{ "minval",  1,       BOND_VALFLAG_MIN | BOND_VALFLAG_DEFAULT},
 	{ "maxval",  INT_MAX, BOND_VALFLAG_MAX},
+	{ NULL,      -1,      0},	
 };
 
 static struct bond_option bond_opts[] = {
-- 
1.7.2.5

