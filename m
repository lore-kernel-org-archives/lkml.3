Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbbAGKTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:19:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56481 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbbAGKTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:19:05 -0500
Date: Wed, 7 Jan 2015 11:19:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wireless extensions should default to Y
Message-ID: <20150107101903.GA6563@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we need following patch on top of
24a0aa212ee2dbe44360288684478d76a8e20a0a revert?

I updated kernel today, and (probably because extensions were not
selectable before), the default choice was "N", which is wrong:
oldconfig should result in compatible choices being made, for example
to help bisect.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 29c8675..8951dba 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -177,6 +177,7 @@ config CFG80211_INTERNAL_REGDB
 config CFG80211_WEXT
 	bool "cfg80211 wireless extensions compatibility"
 	depends on CFG80211
+	default y
 	select WEXT_CORE
 	help
 	  Enable this option if you need old userspace for wireless


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
