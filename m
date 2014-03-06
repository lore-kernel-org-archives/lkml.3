Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaCFSEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:04:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51292 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaCFSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:04:05 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: fubar@us.ibm.com, vfalico@redhat.com, andy@greyhouse.net
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikolay@redhat.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] bonding: correctly handle out of range parameters for lp_interval
Date: Thu,  6 Mar 2014 13:03:50 -0500
Message-Id: <1394129030-9947-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We didn't correctly check cases where the value for lp_interval is not
within the legal range due to a missing table terminator.

This would let userspace trigger a kernel panic by specifying a value out
of range:

	echo -1 > /sys/devices/virtual/net/bond0/bonding/lp_interval

Introduced by commit "bonding: add infrastructure for an option API".

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

