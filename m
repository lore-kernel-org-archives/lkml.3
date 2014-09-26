Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaIZJqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbaIZJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 078/142] ASoC: adau1701: fix adau1701_reg_read()
Date: Fri, 26 Sep 2014 11:44:49 +0200
Message-Id: <9e5cee313366d72939f6991ef0a265c8c8da6404.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3ad80b828b2533f37c221e2df155774efd6ed814 upstream.

Fix a long standing bug in the read register routing of adau1701.
The bytes arrive in the buffer in big-endian, so the result has to be
shifted before and-ing the bytes in the loop.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/adau1701.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index adee866f463f..56bfc679f437 100644
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
2.1.0

