Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaBUTl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:41:26 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:58997 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbaBUTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:41:08 -0500
Date: Fri, 21 Feb 2014 20:41:06 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [GIT PULL REQUEST] watchdog - v3.14-rc4 Fixes
Message-ID: <20140221194106.GN1484@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It corrects the error code when no device was found for w83697hf_wdt.

This will update the following files:

 w83697hf_wdt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

with these Changes:

commit 0cb1c3e853e0d0f996f4e11863407bf31e6b7343
Author: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Date:   Mon Jan 27 11:04:33 2014 +0400

    watchdog: w83697hf_wdt: return ENODEV if no device was found
    
    Most WDT driver modules return ENODEV during modprobe if
    no valid device was found, but w83697hf_wdt returns EIO.
    
    Let w83697hf_wdt return ENODEV.
    
    Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index aaf2995..68b45fc 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -402,7 +402,7 @@ static int __init wdt_init(void)
 
 	if (!found) {
 		pr_err("No W83697HF/HG could be found\n");
-		ret = -EIO;
+		ret = -ENODEV;
 		goto out;
 	}
 
