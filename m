Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaD1Bcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Linus Walleij" <linus.walleij@linaro.org>,
        "Lee Jones" <lee.jones@linaro.org>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.750953638@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 51/94] mfd: Include all drivers in subsystem menu
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit a6e6e660baa5c583022e3e48c85316bace027825 upstream.

It is currently not possible to select the SA1100 or Vexpress
drivers in the MFD subsystem, because the menu for the entire
subsystem ends before these options are presented.

Move the main menu closing and the endif for HAS_IOMEM to the
end of the file so these are selectable again.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -772,9 +772,6 @@ config MFD_INTEL_MSIC
 	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
 	  devices used in Intel Medfield platforms.
 
-endmenu
-endif
-
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
 
@@ -797,3 +794,6 @@ config MCP_UCB1200_TS
 	depends on MCP_UCB1200 && INPUT
 
 endmenu
+
+endmenu
+endif

