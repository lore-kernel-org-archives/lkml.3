Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbaIOXDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:03:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaIOWNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/187] ASoC: adau1701: fix adau1701_reg_read()
Date: Mon, 15 Sep 2014 15:07:48 -0700
Message-Id: <1410818997-9432-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 3ad80b828b2533f37c221e2df155774efd6ed814 upstream.

Fix a long standing bug in the read register routing of adau1701.
The bytes arrive in the buffer in big-endian, so the result has to be
shifted before and-ing the bytes in the loop.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/adau1701.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index adee866..56bfc67 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -230,8 +230,10 @@ static int adau1701_reg_read(void *context, unsigned int reg,
 
 	*value = 0;
 
-	for (i = 0; i < size; i++)
-		*value |= recv_buf[i] << (i * 8);
+	for (i = 0; i < size; i++) {
+		*value <<= 8;
+		*value |= recv_buf[i];
+	}
 
 	return 0;
 }
-- 
1.9.1

