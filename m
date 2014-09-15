Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaIOUXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:23:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbaIOThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 056/114] ASoC: adau1701: fix adau1701_reg_read()
Date: Mon, 15 Sep 2014 12:25:56 -0700
Message-Id: <20140915192643.190674826@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 3ad80b828b2533f37c221e2df155774efd6ed814 upstream.

Fix a long standing bug in the read register routing of adau1701.
The bytes arrive in the buffer in big-endian, so the result has to be
shifted before and-ing the bytes in the loop.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/adau1701.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -230,8 +230,10 @@ static int adau1701_reg_read(void *conte
 
 	*value = 0;
 
-	for (i = 0; i < size; i++)
-		*value |= recv_buf[i] << (i * 8);
+	for (i = 0; i < size; i++) {
+		*value <<= 8;
+		*value |= recv_buf[i];
+	}
 
 	return 0;
 }


