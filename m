Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaLEXe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:34:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaLEW4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.17 073/122] brcmfmac: dont include linux/unaligned/access_ok.h
Date: Fri,  5 Dec 2014 14:44:07 -0800
Message-Id: <20141205223316.770127322@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a1d69c60c44134f64945bbf6a6dfda22eaf4a214 upstream.

This is a specific implementation, <asm/unaligned.h> is the
multiplexer that has the arch-specific knowledge of which
of the implementations needs to be used, so include that.

This issue was revealed by kbuild testing
when <asm/unaligned.h> was added in <linux/ieee80211.h>
resulting in redefinition of get_unaligned_be16 (and
probably others).

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -19,10 +19,10 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
-#include <linux/unaligned/access_ok.h>
 #include <linux/interrupt.h>
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
+#include <asm/unaligned.h>
 
 #include <soc.h>
 #include <chipcommon.h>


