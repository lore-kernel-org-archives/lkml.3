Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3EMIf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:35:26 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60206 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab3EMIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:35:24 -0400
Message-ID: <1368434121.1350.27.camel@x61.thuisdomein>
Subject: [PATCH] bcache: drop "select CLOSURES"
From: Paul Bolle <pebolle@tiscali.nl>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 10:35:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 08:35:22.0165 (UTC) FILETIME=[CEBEEE50:01CE4FB4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for BCACHE selects CLOSURES. But there's no Kconfig
symbol CLOSURES. That symbol was used in development versions of bcache,
but was removed when the closures code was no longer provided as a
kernel library. It can safely be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Basically untested.

 drivers/md/bcache/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 05c220d..f950c9d 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -1,7 +1,6 @@
 
 config BCACHE
 	tristate "Block device as cache"
-	select CLOSURES
 	---help---
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
-- 
1.7.11.7

