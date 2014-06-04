Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFDOqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:46:43 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62044 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaFDOqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:46:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: add regulator_can_change_voltage stub
Date: Wed, 04 Jun 2014 16:46 +0200
Message-ID: <4605709.T97aRyQTUM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:P4CXyV8CmrjJB4BXL9MoNqybCbERmuZxvxsd2eApnNN
 c5QaEW3goSwYLbvIeFUEQRQt1M/rlcsrvyqTRf8K7IPbsyTT33
 i+bzEWQAOsAwzyb7lNBG4J64OTJTYrmRBv1sN4JmgpwStfFGVt
 KqHWGrdSIwBClVv20rxQiVxcjiPZ28kz3cyujCv53Jlsx9d7yP
 v7GWD9Fkt87xV2VXAh90qzgxynhmxtIaBWW0vhx1P8aDturosv
 87uPYK5qT5kGRvgu7q7BO+3bkQQEpUwOHw6WgoM5p6XEBAjAF6
 N2l3Aim9o/s8rAjfL/OsDhl/bqoeh9eK2s+cZ5FSmVqdA/jO5d
 SF9yORnWFFsNu5661sWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_REGULATOR is not set, we cannot call
regulator_can_change_voltage() from a device driver, which results
in a build error like

video/fbdev/omap2/dss/hdmi5.c: In function 'hdmi_init_regulator':
video/fbdev/omap2/dss/hdmi5.c:149:2: error: implicit declaration of function 'regulator_can_change_voltage' [-Werror=implicit-function-declaration]

even for drivers that don't require the regulator API normally.
Such a use was recently added in the omap2+ hdmi driver.

This avoids the problem by adding a static inline function
stub in the API header, as we have for most of the other
regulator functions as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index a2d9d81..14ec18d 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -395,6 +395,11 @@ static inline void regulator_bulk_free(int num_consumers,
 {
 }
 
+static inline int regulator_can_change_voltage(struct regulator *regulator)
+{
+	return 0;
+}
+
 static inline int regulator_set_voltage(struct regulator *regulator,
 					int min_uV, int max_uV)
 {

