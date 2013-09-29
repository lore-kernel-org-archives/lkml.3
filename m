Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3I2T1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:27:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3I2T1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>, Zijie Pan <zijie.pan@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/17] Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()"
Date: Sun, 29 Sep 2013 12:26:40 -0700
Message-Id: <20130929190757.254907630@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
References: <20130929190757.138351117@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b23270416da409bd4e637a5acbe31a1126235fb6 which is
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
@@ -1604,9 +1604,8 @@ static int sctp_cmd_interpreter(sctp_eve
 					asoc->outqueue.outstanding_bytes;
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
-			chunk->subh.sack_hdr = &sackh;
 			sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK,
-					SCTP_CHUNK(chunk));
+					SCTP_SACKH(&sackh));
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:


