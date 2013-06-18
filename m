Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab3FRQTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:19:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab3FRQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:29 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Schichan <nschichan@freebox.fr>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 48/48] ARM: Kirkwood: handle mv88f6282 cpu in __kirkwood_variant().
Date: Tue, 18 Jun 2013 09:18:14 -0700
Message-Id: <20130618161732.916831479@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Schichan <nschichan@freebox.fr>

commit 4089fe95bfed295c8ad38251d5fe02b6b0ba684c upstream.

MPP_F6281_MASK would be previously be returned when on mv88f6282,
which would disallow some valid MPP configurations.

Commit 830f8b91 (arm: plat-orion: fix printing of "MPP config
unavailable on this hardware") made this problem visible as an invalid
MPP configuration is now correctly detected and not applied.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-kirkwood/mpp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-kirkwood/mpp.c
+++ b/arch/arm/mach-kirkwood/mpp.c
@@ -22,9 +22,10 @@ static unsigned int __init kirkwood_vari
 
 	kirkwood_pcie_id(&dev, &rev);
 
-	if ((dev == MV88F6281_DEV_ID && rev >= MV88F6281_REV_A0) ||
-	    (dev == MV88F6282_DEV_ID))
+	if (dev == MV88F6281_DEV_ID && rev >= MV88F6281_REV_A0)
 		return MPP_F6281_MASK;
+	if (dev == MV88F6282_DEV_ID)
+		return MPP_F6282_MASK;
 	if (dev == MV88F6192_DEV_ID && rev >= MV88F6192_REV_A0)
 		return MPP_F6192_MASK;
 	if (dev == MV88F6180_DEV_ID)


