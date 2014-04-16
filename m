Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbaDPUr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:47:29 -0400
Received: from mxip5-inbound.gatech.edu ([130.207.182.47]:32500 "EHLO
	mxip5-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDPUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:47:28 -0400
X-RemoteIP: 130.207.185.164
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 81216310
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.97,874,1389762000"; 
   d="scan'208";a="81216310"
X-GT-Spam-Rating: (0%)
Message-ID: <534EEC6B.8030500@gatech.edu>
Date: Wed, 16 Apr 2014 16:47:39 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kernel/rcu/rcutorture.c: use macro to define module parameter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use the defined macro for module parameter definition

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/rcutorture.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index bd30bc6..1a0298c 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -143,9 +143,8 @@ static struct list_head rcu_torture_removed;
 #else
 #define RCUTORTURE_RUNNABLE_INIT 0
 #endif
-int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
-module_param(rcutorture_runnable, int, 0444);
-MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
+torture_param(int, rcutorture_runnable, RCUTORTURE_RUNNABLE_INIT,
+		"Start rcutorture at boot");
 
 #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
 #define rcu_can_boost() 1
-- 
1.7.9.5
