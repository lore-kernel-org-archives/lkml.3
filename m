Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3LMG5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:57:24 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62244 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3LMG5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:57:23 -0500
Date: Fri, 13 Dec 2013 12:27:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        device-drivers-devel@blackfin.uclinux.org
Subject: [PATCH 4/5] drivers: misc: Mark functions as static in ad525x_dpot.c
Message-ID: <e96ca2e8c4c331f556363a7dc2046a07da230e3c.1386915618.git.rashika.kheria@gmail.com>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function ad_dpot_add_files() and
ad_dpot_remove_files() as static in ad525x_dpot.c because they are not
used outside this file.

Thus, it also eliminates the following warnings in ad525x_dpot.c:
drivers/misc/ad525x_dpot.c:644:5: warning: no previous prototype for ‘ad_dpot_add_files’ [-Wmissing-prototypes]
drivers/misc/ad525x_dpot.c:669:13: warning: no previous prototype for ‘ad_dpot_remove_files’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/misc/ad525x_dpot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 0daadcf..d3eee11 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -641,7 +641,7 @@ static const struct attribute_group ad525x_group_commands = {
 	.attrs = ad525x_attributes_commands,
 };
 
-int ad_dpot_add_files(struct device *dev,
+static int ad_dpot_add_files(struct device *dev,
 		unsigned features, unsigned rdac)
 {
 	int err = sysfs_create_file(&dev->kobj,
@@ -666,7 +666,7 @@ int ad_dpot_add_files(struct device *dev,
 	return err;
 }
 
-inline void ad_dpot_remove_files(struct device *dev,
+static inline void ad_dpot_remove_files(struct device *dev,
 		unsigned features, unsigned rdac)
 {
 	sysfs_remove_file(&dev->kobj,
-- 
1.7.9.5

