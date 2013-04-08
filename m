Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab3DHDs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:48:58 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61056 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444Ab3DHDs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:48:57 -0400
X-Spam-Score: -100.7
Message-ID: <51623E0B.7070101@asianux.com>
Date: Mon, 08 Apr 2013 11:48:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: events: strncpy, always be sure of NUL terminated.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for NUL terminated string, always be sure of '\0' at the end.
  
  in our case, need return value, so still use strncpy
    (strlcpy return the size, not the pointer)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/events/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4757941..bdc0e25 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4752,7 +4752,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	} else {
 		if (arch_vma_name(mmap_event->vma)) {
 			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
-				       sizeof(tmp));
+				       sizeof(tmp) - 1);
+			tmp[sizeof(tmp) - 1] = '\0';
 			goto got_name;
 		}
 
-- 
1.7.7.6
