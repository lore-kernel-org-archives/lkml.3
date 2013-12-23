Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3LWQ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:29:15 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39418 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab3LWQYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:06 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC 07/18] regmap: debugfs: Always create "registers" & "access" files
Date: Mon, 23 Dec 2013 16:23:39 +0000
Message-Id: <1387815830-8794-8-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:03.0775 (UTC) FILETIME=[651014F0:01CEFFFB]
X-MC-Unique: 113122316240405101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGTLAU026679

When a map covers a single register, max_register is equal
to 0, so the "registers" & "access" files were not created.

This patch is removing this restriction. It should be save,
as the maps not without register 0 should return false
for regmap_readable(map, 0).

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-debugfs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c5471cd..17cd35a 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -511,12 +511,10 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	debugfs_create_file("range", 0400, map->debugfs,
 			    map, &regmap_reg_ranges_fops);
 
-	if (map->max_register) {
-		debugfs_create_file("registers", 0400, map->debugfs,
-				    map, &regmap_map_fops);
-		debugfs_create_file("access", 0400, map->debugfs,
-				    map, &regmap_access_fops);
-	}
+	debugfs_create_file("registers", 0400, map->debugfs,
+			map, &regmap_map_fops);
+	debugfs_create_file("access", 0400, map->debugfs,
+			map, &regmap_access_fops);
 
 	if (map->cache_type) {
 		debugfs_create_bool("cache_only", 0400, map->debugfs,
-- 
1.8.3.2


