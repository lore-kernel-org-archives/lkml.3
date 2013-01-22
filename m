Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3AVVYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:24:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3AVVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:24:50 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lib: devres: Fix build breakage
Date: Tue, 22 Jan 2013 22:24:46 +0100
Message-Id: <1358889886-8502-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:/jXv7gzjlni9UqeU85ISwvQERXIUkNbGaVokqVACcq6
 cmMRRABASSKsEeaJjQ5Li7xDbz4B6EwtetlZoQM/9NMQJ5Be2r
 7LZu0gjjcMSH29MHw4oN1Jh5ZbQ7+XSwQa89S2GXvO7FqT9Igh
 KBsERFLazA0JQeAXsJLSZxPUVKJMqqmJOhf3Tr4uZACD3hB31T
 6XtVXnqwX3wYuA2xdfcb2gt3oOopY6FSLgdhnMx/DDAZHNLqG6
 Ite72bx79uY4MqWrSolLd/WK1ZK0J+dWFnpavxBVr9R7Oycg3r
 zMLxEVqA1m7gh2lilByQo8VT0AlI6pLqXIoM9glxwb6kWHy9A0
 /cx5pqu8qoa6187AOGXdENgh3XUQLg6cKnEBeXxdWP4xd0Rsh0
 Xz/7QytoD1XHQnd3DvYG6E1jX8kao3m20Wh2BXil9y9cWcmoxT
 9rod+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ERR_PTR() and IS_ERR() macros used by the devm_ioremap_resource()
function are defined in the linux/err.h header. On ARM this seems to be
pulled in by one of the other headers but the build fails at least on
OpenRISC.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 lib/devres.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/devres.c b/lib/devres.c
index 9c76b3a..88ad759 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -1,3 +1,4 @@
+#include <linux/err.h>
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
-- 
1.8.1.1

