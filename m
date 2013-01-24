Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3AXDji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:39:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3AXDaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@risingtidesystems.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 37/74] target: use correct sense code for LUN communication failure
Date: Thu, 24 Jan 2013 01:26:49 -0200
Message-Id: <1358998046-613-38-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 18a9df42d53fabfa43b78be1104838cc8b9762e1 upstream.

The ASC/ASCQ code for 'Logical Unit Communication failure' is
0x08/0x00; 0x80/0x00 is vendor specific.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: adjust context, additional offset added ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7879ff4..cf05182 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4231,7 +4231,7 @@ int transport_send_check_condition_and_sense(
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT COMMUNICATION FAILURE */
-		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x80;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x08;
 		break;
 	}
 	/*
-- 
1.7.9.5

