Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaEDRBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:01:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaEDPlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Suman Anna <s-anna@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 3.14 008/158] ARM: OMAP2+: hwmod: fix missing braces in _init()
Date: Sun,  4 May 2014 11:38:37 -0400
Message-Id: <20140504154031.158262827@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Anna <s-anna@ti.com>

commit 3d36ad7e7a9be0d130c862727a052ed279046437 upstream.

Bug was introduced by commit 'f92d959: ARM: OMAP2+: hwmod:
Extract no-idle and no-reset info from DT'

There were 2 versions of the patch posted which resulted in the above
commit. While v1 [1] had the bug, v2 [2] had it fixed.
However v1 apparently seemed to have been pulled in by mistake
introducing the bug.

Given of_find_property() does return NULL when the node passed is
NULL, it did not introduce any functional issues as such, just the
fact that the second if check was executed unnecessarily.

[1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg94220.html
[2] http://www.spinics.net/lists/linux-omap/msg98490.html

Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Fixes: f92d9597f781f6a5a39c73dc71604bd8a21c5299 ("ARM: OMAP2+: hwmod: Extract no-idle and no-reset info from DT")
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2546,11 +2546,12 @@ static int __init _init(struct omap_hwmo
 		return -EINVAL;
 	}
 
-	if (np)
+	if (np) {
 		if (of_find_property(np, "ti,no-reset-on-init", NULL))
 			oh->flags |= HWMOD_INIT_NO_RESET;
 		if (of_find_property(np, "ti,no-idle-on-init", NULL))
 			oh->flags |= HWMOD_INIT_NO_IDLE;
+	}
 
 	oh->_state = _HWMOD_STATE_INITIALIZED;
 


