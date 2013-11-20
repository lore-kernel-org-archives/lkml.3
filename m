Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3KTUX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:23:59 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58824 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3KTUWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:22:02 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 1/7] net: phy: marvell: provide genphy suspend/resume
Date: Wed, 20 Nov 2013 21:21:47 +0100
Message-Id: <1384978913-8052-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell PHYs support generic PHY suspend/resume, so provide those
callbacks to all marvell specific drivers.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/marvell.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2e3c778e..bd37e45 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -894,6 +894,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -907,6 +909,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -920,6 +924,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &marvell_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -933,6 +939,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = {.owner = THIS_MODULE,},
 	},
 	{
@@ -946,6 +954,8 @@ static struct phy_driver marvell_drivers[] = {
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
 		.did_interrupt = &m88e1121_did_interrupt,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -961,6 +971,8 @@ static struct phy_driver marvell_drivers[] = {
 		.did_interrupt = &m88e1121_did_interrupt,
 		.get_wol = &m88e1318_get_wol,
 		.set_wol = &m88e1318_set_wol,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -974,6 +986,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -987,6 +1001,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -1000,6 +1016,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -1013,6 +1031,8 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = &genphy_read_status,
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
@@ -1026,6 +1046,8 @@ static struct phy_driver marvell_drivers[] = {
 		.ack_interrupt = &marvell_ack_interrupt,
 		.config_intr = &marvell_config_intr,
 		.did_interrupt = &m88e1121_did_interrupt,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
 		.driver = { .owner = THIS_MODULE },
 	},
 };
-- 
1.7.2.5

