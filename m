Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab3DPS10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab3DPS1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 20/28] hostap: proc: Use remove_proc_subtree() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Jouni Malinen <j@w1.fi>,
        linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 16 Apr 2013 19:27:07 +0100
Message-ID: <20130416182706.27773.46011.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use remove_proc_subtree() rather than remove_proc_entry() to remove a
device-specific proc directory and all its children.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jouni Malinen <j@w1.fi>
cc: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/net/wireless/hostap/hostap_proc.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
index 89292cf..7491dab 100644
--- a/drivers/net/wireless/hostap/hostap_proc.c
+++ b/drivers/net/wireless/hostap/hostap_proc.c
@@ -496,25 +496,7 @@ void hostap_init_proc(local_info_t *local)
 
 void hostap_remove_proc(local_info_t *local)
 {
-	if (local->proc != NULL) {
-#ifndef PRISM2_NO_STATION_MODES
-		remove_proc_entry("scan_results", local->proc);
-#endif /* PRISM2_NO_STATION_MODES */
-#ifdef PRISM2_IO_DEBUG
-		remove_proc_entry("io_debug", local->proc);
-#endif /* PRISM2_IO_DEBUG */
-		remove_proc_entry("pda", local->proc);
-		remove_proc_entry("aux_dump", local->proc);
-		remove_proc_entry("wds", local->proc);
-		remove_proc_entry("stats", local->proc);
-		remove_proc_entry("bss_list", local->proc);
-		remove_proc_entry("crypt", local->proc);
-#ifndef PRISM2_NO_PROCFS_DEBUG
-		remove_proc_entry("debug", local->proc);
-#endif /* PRISM2_NO_PROCFS_DEBUG */
-		if (hostap_proc != NULL)
-			remove_proc_entry(local->proc->name, hostap_proc);
-	}
+	remove_proc_subtree(local->ddev->name, hostap_proc);
 }
 
 

