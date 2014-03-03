Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaCCUrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:47:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43333 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaCCUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:47:03 -0500
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <morbidrsa@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 2/2] iio: adc: Fix build error discovered by 0-day build bot
Date: Mon,  3 Mar 2014 21:46:49 +0100
Message-Id: <1393879609-3284-2-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393879609-3284-1-git-send-email-johannes.thumshirn@men.de>
References: <1393879609-3284-1-git-send-email-johannes.thumshirn@men.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Thumshirn <morbidrsa@gmail.com>

men_z188_adc needs to include linux/io.h. This fixes a build error
discovered by 0-day buid bot

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/iio/adc/men_z188_adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/men_z188_adc.c b/drivers/iio/adc/men_z188_adc.c
index 7036503..6989c16 100644
--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mcb.h>
+#include <linux/io.h>
 #include <linux/iio/iio.h>
 
 #define Z188_ADC_MAX_CHAN	8
-- 
1.8.5.3

