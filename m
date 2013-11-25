Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3KYKCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:02:08 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:60130 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3KYKCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:02:04 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 05:02:04 EST
X-LoopCount0: from 10.175.216.249
X-IronPort-AV: E=Sophos;i="4.93,766,1378875600"; 
   d="scan'208";a="331632874"
From: <Srinivas_G_Gowda@Dell.com>
To: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Date: Mon, 25 Nov 2013 15:21:09 +0530
Subject: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer cmd
Thread-Topic: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Index: Ac7pw94S9pVXI0uVQjOjL/E/krBNeA==
Message-ID: <52931C2D.4070908@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Setting up mod_timer() for IPMI_READ_EVENT_MSG_BUFFER_CMD. 
 Driver stalls in case we hit error cases for IPMI_READ_EVENT_MSG_BUFFER_CMD.

Signed-off-by: Srinivas Gowda <srinivas_g_gowda@dell.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 15e4a60..affcc52 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -843,6 +843,9 @@ static enum si_sm_result smi_event_handler(struct smi_info *smi_info,
 		smi_info->curr_msg->data[1] = IPMI_READ_EVENT_MSG_BUFFER_CMD;
 		smi_info->curr_msg->data_size = 2;
 
+		smi_info->last_timeout_jiffies = jiffies;
+		mod_timer(&smi_info->si_timer, (jiffies + SI_TIMEOUT_JIFFIES));
+
 		smi_info->handlers->start_transaction(
 			smi_info->si_sm,
 			smi_info->curr_msg->data,
-- 
1.8.1.2
