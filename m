Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3I2T1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:27:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3I2T1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>, Zijie Pan <zijie.pan@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/22] Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()"
Date: Sun, 29 Sep 2013 12:26:47 -0700
Message-Id: <20130929191158.989181071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191158.889693326@linuxfoundation.org>
References: <20130929191158.889693326@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c2f5b7507ac5d808f29287d77ee6148358d7fbfe which is
commit f6e80abeab928b7c47cc1fbf53df13b4398a2bec.

Michal writes:
	Mainline commit f6e80abe was introduced in v3.7-rc2 as a
	follow-up fix to commit

	  edfee033  sctp: check src addr when processing SACK to update transport state

	(from v3.7-rc1) which changed the interpretation of third
	argument to sctp_cmd_process_sack() and sctp_outq_sack(). But as
	commit edfee033 has never been backported to stable branches,
	backport of commit f6e80abe actually breaks the code rather than
	fixing it.

Reported-by: Michal Kubecek <mkubecek@suse.cz>
Cc: Zijie Pan <zijie.pan@6wind.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sctp/sm_sideeffect.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1610,9 +1610,8 @@ static int sctp_cmd_interpreter(sctp_eve
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
-			chunk->subh.sack_hdr = &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_CHUNK(chunk));
+					SCTP_SACKH(&sackh));
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:


