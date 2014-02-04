Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935845AbaBDWXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:23:49 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:56586 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933662AbaBDWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:23:42 -0500
Message-ID: <1391552620.13156.16.camel@x220>
Subject: [PATCH 2/2] raw: set range for MAX_RAW_DEVS
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 04 Feb 2014 23:23:40 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Feb 2014 22:23:40.0866 (UTC) FILETIME=[C1C62220:01CF21F7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MAX_RAW_DEVS is meant to be between 1 and 65536. But
those boundaries are not enforced by its Kconfig entry.

Note that MAX_RAW_DEVS is used to set MAX_RAW_MINORS in
drivers/char/raw.c. If one would accidentally set MAX_RAW_DEVS to an
invalid value, that invalid value will actually end up being used in
raw_init().

So add an appropriate range to this Kconfig entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/char/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index fa3243d..1386749 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -499,6 +499,7 @@ config RAW_DRIVER
 config MAX_RAW_DEVS
 	int "Maximum number of RAW devices to support (1-65536)"
 	depends on RAW_DRIVER
+	range 1 65536
 	default "256"
 	help
 	  The maximum number of RAW devices that are supported.
-- 
1.8.5.3

