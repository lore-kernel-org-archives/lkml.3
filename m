Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab3JKLIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:08:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3JKKmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Miller <davem@redhat.com>, Michal Kubecek <mkubecek@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 023/100] Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()"
Date: Fri, 11 Oct 2013 11:40:53 +0100
Message-Id: <1381488130-30235-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

This reverts commit 01ee5a524eaa7928e8ee1ae4a0051084cfcaf904 which is
commit f6e80abeab928b7c47cc1fbf53df13b4398a2bec upstream.

Michal Kubecek reported:

Please revert backports of mainline commit

   f6e80abe  sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()

 in stable branches before 3.7, in particular

   stable-3.0.y  b23270416da409bd4e637a5acbe31a1126235fb6  (v3.0.52)
   stable-3.4.y  c2f5b7507ac5d808f29287d77ee6148358d7fbfe  (v3.4.19)

 Mainline commit f6e80abe was introduced in v3.7-rc2 as a follow-up fix
 to commit

   edfee033  sctp: check src addr when processing SACK to update transport state

 (from v3.7-rc1) which changed the interpretation of third argument to
 sctp_cmd_process_sack() and sctp_outq_sack(). But as commit edfee033 has
 never been backported to stable branches, backport of commit f6e80abe
 actually breaks the code rather than fixing it.

Cc: David Miller <davem@redhat.com>
Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/sm_sideeffect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index c461b1c..8716da1 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1609,9 +1609,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
-			chunk->subh.sack_hdr = &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_CHUNK(chunk));
+					SCTP_SACKH(&sackh));
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:
-- 
1.8.3.2

