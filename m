Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3BCPT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:19:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34188 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab3BCOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:28 -0500
Message-Id: <20130203144646.604459483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@risingtidesystems.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 029/128] target: use correct sense code for LUN communication failure
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 18a9df42d53fabfa43b78be1104838cc8b9762e1 upstream.

The ASC/ASCQ code for 'Logical Unit Communication failure' is
0x08/0x00; 0x80/0x00 is vendor specific.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: add offset to buffer index]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4539,7 +4539,7 @@ int transport_send_check_condition_and_s
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT COMMUNICATION FAILURE */
-		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x80;
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x08;
 		break;
 	}
 	/*


