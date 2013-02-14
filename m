Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab3BNKMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48716 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3BNKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:29 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 08/13] vmcore: remove unused helper function
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:27 +0900
Message-ID: <20130214101227.22466.12503.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove map_offset_to_paddr(), which is no longer used.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 4125a65..3aedb52 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -117,27 +117,6 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
-/* Maps vmcore file offset to respective physical address in memroy. */
-static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
-					struct vmcore **m_ptr)
-{
-	struct vmcore *m;
-	u64 paddr;
-
-	list_for_each_entry(m, vc_list, list) {
-		u64 start, end;
-		start = m->offset;
-		end = m->offset + m->size - 1;
-		if (offset >= start && offset <= end) {
-			paddr = m->paddr + offset - start;
-			*m_ptr = m;
-			return paddr;
-		}
-	}
-	*m_ptr = NULL;
-	return 0;
-}
-
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */

