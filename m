Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3H0BOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:14:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3H0BH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>
Subject: [ 57/74] usb: phy: fix build breakage
Date: Mon, 26 Aug 2013 18:08:55 -0700
Message-Id: <20130827010436.385566133@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 52d5b9aba1f5790ca3231c262979c2c3e26dd99b upstream.

Commit 94ae9843 (usb: phy: rename all phy drivers to phy-$name-usb.c)
renamed drivers/usb/phy/otg_fsm.h to drivers/usb/phy/phy-fsm-usb.h
but changed drivers/usb/phy/phy-fsm-usb.c to include not existing
"phy-otg-fsm.h" instead of new "phy-fsm-usb.h". This breaks building:
  ...
  drivers/usb/phy/phy-fsm-usb.c:32:25: fatal error: phy-otg-fsm.h: No such file or directory
  compilation terminated.
  make[3]: *** [drivers/usb/phy/phy-fsm-usb.o] Error 1

This commit also missed to modify drivers/usb/phy/phy-fsl-usb.h
to include new "phy-fsm-usb.h" instead of "otg_fsm.h" resulting
in another build breakage:
  ...
  In file included from drivers/usb/phy/phy-fsl-usb.c:46:0:
  drivers/usb/phy/phy-fsl-usb.h:18:21: fatal error: otg_fsm.h: No such file or directory
  compilation terminated.
  make[3]: *** [drivers/usb/phy/phy-fsl-usb.o] Error 1

Fix both issues.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/phy/phy-fsl-usb.h |    2 +-
 drivers/usb/phy/phy-fsm-usb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/phy/phy-fsl-usb.h
+++ b/drivers/usb/phy/phy-fsl-usb.h
@@ -15,7 +15,7 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include "otg_fsm.h"
+#include "phy-fsm-usb.h"
 #include <linux/usb/otg.h>
 #include <linux/ioctl.h>
 
--- a/drivers/usb/phy/phy-fsm-usb.c
+++ b/drivers/usb/phy/phy-fsm-usb.c
@@ -29,7 +29,7 @@
 #include <linux/usb/gadget.h>
 #include <linux/usb/otg.h>
 
-#include "phy-otg-fsm.h"
+#include "phy-fsm-usb.h"
 
 /* Change USB protocol when there is a protocol change */
 static int otg_set_protocol(struct otg_fsm *fsm, int protocol)


