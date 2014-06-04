Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaFDXWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaFDXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 158/228] bus: mvebu-mbus: allow several windows with the same target/attribute
Date: Wed,  4 Jun 2014 16:23:07 -0700
Message-Id: <20140604232353.090095689@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit b566e782be32145664d96ada3e389f17d32742e5 upstream.

Having multiple windows with the same target and attribute is actually
legal, and can be useful for PCIe windows, when PCIe BARs have a size
that isn't a power of two, and we therefore need to create several
MBus windows to cover the PCIe BAR for a given PCIe interface.

Fixes: fddddb52a6c4 ('bus: introduce an Marvell EBU MBus driver')
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-7-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/mvebu-mbus.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -222,12 +222,6 @@ static int mvebu_mbus_window_conflicts(s
 		 */
 		if ((u64)base < wend && end > wbase)
 			return 0;
-
-		/*
-		 * Check if target/attribute conflicts
-		 */
-		if (target == wtarget && attr == wattr)
-			return 0;
 	}
 
 	return 1;


