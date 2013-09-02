Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3IBHzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:55:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48811 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3IBHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:55:08 -0400
X-Spam-Score: -100.9
Message-ID: <5224441B.9090305@asianux.com>
Date: Mon, 02 Sep 2013 15:54:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: misc: bmp085: remove '__init' from mp085_get_of_properties()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bmp085_get_of_properties() is called by bmp085_init_client() which is
called by bmp085_probe() which is an EXPORT_SYMBOL_GPL function.

bmp085_probe() is really used as a probe function by another modules
(e.g. bmp085-i2c.c, bmp085-spi.c).

Except bmp085_get_of_properties(), all functions have no '__init', so
need remove '__init' from bmp085_get_of_properties() too, or at least,
it will report related warning:

  WARNING: vmlinux.o(.text+0x4c8a07): Section mismatch in reference from the variable .LM171 to the variable .init.text:_bmp085_get_of_properties
  The function .LM171() references
  the variable __init _bmp085_get_of_properties.
  This is often because .LM171 lacks a __init
  annotation or the annotation of _bmp085_get_of_properties is wrong.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/misc/bmp085.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 849e2fe..2704d88 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -374,7 +374,7 @@ int bmp085_detect(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(bmp085_detect);
 
-static void __init bmp085_get_of_properties(struct bmp085_data *data)
+static void bmp085_get_of_properties(struct bmp085_data *data)
 {
 #ifdef CONFIG_OF
 	struct device_node *np = data->dev->of_node;
-- 
1.7.7.6
