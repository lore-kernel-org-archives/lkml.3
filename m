Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3ASBR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:17:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:56359 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3ASBR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@risingtidesystems.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 05/33] target: use correct sense code for LUN communication failure
Date: Fri, 18 Jan 2013 17:16:30 -0800
Message-Id: <20130119010347.642830884@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 18a9df42d53fabfa43b78be1104838cc8b9762e1 upstream.

The ASC/ASCQ code for 'Logical Unit Communication failure' is
0x08/0x00; 0x80/0x00 is vendor specific.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3024,7 +3024,7 @@ int transport_send_check_condition_and_s
 		/* ILLEGAL REQUEST */
 		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT COMMUNICATION FAILURE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x80;
+		buffer[SPC_ASC_KEY_OFFSET] = 0x08;
 		break;
 	}
 	/*


