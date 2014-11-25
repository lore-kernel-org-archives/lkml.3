Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaKYUTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:19:38 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51388 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaKYUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:19:37 -0500
From: Olof Johansson <olof@lixom.net>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] regmap: provide dummy regmap_exit()
Date: Tue, 25 Nov 2014 12:21:50 -0800
Message-Id: <1416946910-23329-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build error:

sound/soc/soc-core.c: In function 'snd_soc_component_exit_regmap':
sound/soc/soc-core.c:2644:2: error: implicit declaration of function 'regmap_exit' [-Werror=implicit-function-declaration]
  regmap_exit(component->regmap);

Due to the other regmap functions providing appropriate stubs when
!CONFIG_REGMAP, but this one is missing. Add it.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 include/linux/regmap.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4419b99..efb58a0 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -737,6 +737,11 @@ static inline struct regmap *dev_get_regmap(struct device *dev,
 	return NULL;
 }
 
+static inline void regmap_exit(struct regmap *map)
+{
+	return;
+}
+
 static inline struct device *regmap_get_device(struct regmap *map)
 {
 	WARN_ONCE(1, "regmap API is disabled");
-- 
1.7.10.4

