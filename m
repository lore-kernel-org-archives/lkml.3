Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3JUI5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:57:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab3JUIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.492651499@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 139/149] Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK
 in sctp_cmd_interpreter()"
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit de77b7955c3985ca95f64af3cb10557eb17eacee, which was
commit f6e80abeab928b7c47cc1fbf53df13b4398a2bec upstream.

This fix was only appropriate for Linux 3.7 onward, and introduced a
regression when applied to earlier versions.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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

