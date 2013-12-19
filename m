Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3LSI5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:57:02 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35052 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:57:00 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v3=208/8=5D=20drivers=3A=20net=3A=20Mark=20function=20xenvif=5Fcount=5Ffrag=5Fslots=28=29=20as=20static=20in=20netback=2Ec?=
Date: Thu, 19 Dec 2013 14:26:47 +0530
Message-Id: <72d6fe114ba7cc2f09f51e279313860f83142d46.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function xenvif_count_frag_slots() in netback.c as
static because they are not used outside this file.

Thus, it also removes the following warning in xen-netback/netback.c:
drivers/net/xen-netback/netback.c:218:14: warning: no previous prototype for ‘xenvif_count_frag_slots’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/net/xen-netback/netback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 64f0e0d..9e4f399 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -215,7 +215,7 @@ struct xenvif_count_slot_state {
 	bool head;
 };
 
-unsigned int xenvif_count_frag_slots(struct xenvif *vif,
+static unsigned int xenvif_count_frag_slots(struct xenvif *vif,
 				     unsigned long offset, unsigned long size,
 				     struct xenvif_count_slot_state *state)
 {
-- 
1.7.9.5

