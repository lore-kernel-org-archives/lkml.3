Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3EQM0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:26:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33824 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3EQM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:26:04 -0400
X-Spam-Score: -100.8
Message-ID: <519621A6.3010809@asianux.com>
Date: Fri, 17 May 2013 20:25:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, walken@google.com, riel@redhat.com,
        khlebnikov@openvz.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/nommu.c: add additional check for vread() just like vwrite()
 has done.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since vwrite() has already check whether overflow, as a pair function,
vread() also need do the same thing.

Since vwrite() check the source buffer address, vread() should check
the destination buffer address.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 mm/nommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 886e07c..0614ee1 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -282,6 +282,10 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 long vread(char *buf, char *addr, unsigned long count)
 {
+	/* Don't allow overflow */
+	if ((unsigned long) buf + count < count)
+		count = -(unsigned long) buf;
+
 	memcpy(buf, addr, count);
 	return count;
 }
-- 
1.7.7.6
