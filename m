Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaKYVBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:01:12 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59295 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKYVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:01:10 -0500
From: Olof Johansson <olof@lixom.net>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v2] regmap: provide dummy regmap_exit()
Date: Tue, 25 Nov 2014 13:03:19 -0800
Message-Id: <1416949399-29718-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5474E91E.6000401@metafoo.de>
References: <5474E91E.6000401@metafoo.de>
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
 include/linux/regmap.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4419b99..a13e2bf 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -737,6 +737,8 @@ static inline struct regmap *dev_get_regmap(struct device *dev,
 	return NULL;
 }
 
+static inline void regmap_exit(struct regmap *map) { }
+
 static inline struct device *regmap_get_device(struct regmap *map)
 {
 	WARN_ONCE(1, "regmap API is disabled");
-- 
1.7.10.4

