Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab3CGJBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:01:07 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:23764 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3CGJBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:01:05 -0500
Message-ID: <51385734.10206@huawei.com>
Date: Thu, 7 Mar 2013 17:00:36 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH 7/8] ethernet/emac/sysrq: fix inconstistent help message of
 sysrq key
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch ethernet emac sysrq key: "emac(c)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/emac/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/debug.c b/drivers/net/ethernet/ibm/emac/debug.c
index b16b482..a559f32 100644
--- a/drivers/net/ethernet/ibm/emac/debug.c
+++ b/drivers/net/ethernet/ibm/emac/debug.c
@@ -245,7 +245,7 @@ static void emac_sysrq_handler(int key)

 static struct sysrq_key_op emac_sysrq_op = {
 	.handler = emac_sysrq_handler,
-	.help_msg = "emaC",
+	.help_msg = "emac(c)",
 	.action_msg = "Show EMAC(s) status",
 };

-- 
1.7.9.7


