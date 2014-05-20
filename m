Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaETV2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:28:12 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64144 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaETV2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:28:11 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rupesh Gujare <rupesh.gujare@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ozwpan: ozproto.c:  Fix for possible null pointer dereference
Date: Tue, 20 May 2014 23:28:59 +0200
Message-Id: <1400621339-7514-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ozwpan/ozproto.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index f09acd0..158e0d2 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -765,7 +765,10 @@ static char *oz_get_next_device_name(char *s, char *dname, int max_size)
 int oz_protocol_init(char *devs)
 {
 	skb_queue_head_init(&g_rx_queue);
-	if (devs && (devs[0] == '*')) {
+	if (!devs) {
+		return 0;
+	}
+	if (devs[0] == '*') {
 		oz_binding_add(NULL);
 	} else {
 		char d[32];
-- 
1.7.10.4

