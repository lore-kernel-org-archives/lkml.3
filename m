Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3EJPNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:13:33 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58519
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab3EJPNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:13:31 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Stable <stable@vger.kernel.org> (V3.9)
Subject: [PATCH 1/1] Staging: hv: Fix a bug in get_vp_index()
Date: Fri, 10 May 2013 08:47:01 -0700
Message-Id: <1368200821-20964-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux' notion of cpuid is different from the Host's notion of CPUID. In the
call to bind the channel interrupts, we should use the host's notion of
CPU Ids. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stable <stable@vger.kernel.org> (V3.9)
---
 drivers/hv/channel_mgmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index bad8128..21ef689 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -329,7 +329,7 @@ static u32 get_vp_index(uuid_le *type_guid)
 		return 0;
 	}
 	cur_cpu = (++next_vp % max_cpus);
-	return cur_cpu;
+	return hv_context.vp_index[cur_cpu];
 }
 
 /*
-- 
1.7.4.1

