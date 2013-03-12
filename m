Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab3CLVtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:49:14 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:64555 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732Ab3CLVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:49:13 -0400
Message-ID: <1363124951.3137.156.camel@x61.thuisdomein>
Subject: [PATCH] powerpc/qe: remove useless Kconfig default
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 22:49:11 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2013 21:49:12.0100 (UTC) FILETIME=[6EC9BE40:01CE1F6B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for QE_USB contains
	default y if USB_GADGET_FSL_QE

But USB_GADGET_FSL_QE got removed in commit
193ab2a6070039e7ee2b9b9bebea754a7c52fd1b ("usb: gadget: allow multiple
gadgets to be built"). This default will therefor never be set and can
be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=powerpc menuconfig" and "make ARCH=powerpc
oldconfig" (before and after the patch). Enough to see this patch didn't
obviously break stuff.

1) I don't really understand commit
193ab2a6070039e7ee2b9b9bebea754a7c52fd1b. Was its point that we replace
USB_GADGET_FSL_QE with USB_FSL_QE? I couldn't tell and chose not to
actually change any behavior.

 arch/powerpc/sysdev/qe_lib/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/sysdev/qe_lib/Kconfig b/arch/powerpc/sysdev/qe_lib/Kconfig
index 41ac3df..33caf44 100644
--- a/arch/powerpc/sysdev/qe_lib/Kconfig
+++ b/arch/powerpc/sysdev/qe_lib/Kconfig
@@ -22,6 +22,5 @@ config UCC
 
 config QE_USB
 	bool
-	default y if USB_GADGET_FSL_QE
 	help
 	  QE USB Controller support
-- 
1.7.11.7

