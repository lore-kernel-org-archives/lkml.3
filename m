Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaE0XO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:14:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35304 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE0XO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:14:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org
Cc: speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] Staging: speakup: don't die if accessing sysfs without synth
Date: Tue, 27 May 2014 19:08:36 -0400
Message-Id: <1401232116-31740-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting a 'silent' parameter without a synth would crash the kernel.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/staging/speakup/synth.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 0b3549b..172cf62 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -212,6 +212,9 @@ void synth_start(void)
 
 void spk_do_flush(void)
 {
+	if (!synth)
+		return;
+
 	speakup_info.flushing = 1;
 	synth_buffer_clear();
 	if (synth->alive) {
-- 
1.7.10.4

