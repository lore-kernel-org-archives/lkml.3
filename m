Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaHGQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801AbaHGQi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:38:27 -0400
Date: Thu, 7 Aug 2014 12:38:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: pmoore@redhat.com, jmorris@namei.org
Subject: selinux: fix uninitalised stack variable read in sel_netport_init
Message-ID: <20140807163818.GA27618@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, pmoore@redhat.com,
	jmorris@namei.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the removal of the avc_add_callback() in commit 615e51fdda6
("selinux: reduce the number of calls to synchronize_net() when flushing caches"),
ret is never set to anything, but we return uninitialized stack data on success.

Given the absense of other failure paths, just explicitly return 0.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index 73ac6784d091..3311cc393cb4 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -237,7 +237,6 @@ void sel_netport_flush(void)
 static __init int sel_netport_init(void)
 {
 	int iter;
-	int ret;
 
 	if (!selinux_enabled)
 		return 0;
@@ -247,7 +246,7 @@ static __init int sel_netport_init(void)
 		sel_netport_hash[iter].size = 0;
 	}
 
-	return ret;
+	return 0;
 }
 
 __initcall(sel_netport_init);
