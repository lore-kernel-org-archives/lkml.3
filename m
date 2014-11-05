Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaKEOBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:01:14 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55066 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKEOBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:01:09 -0500
Message-ID: <545A2DA2.40200@plexistor.com>
Date: Wed, 05 Nov 2014 16:01:06 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/5] axonram: Fix bug in direct_access
References: <545A2D69.8090003@plexistor.com>
In-Reply-To: <545A2D69.8090003@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew.r.wilcox@intel.com>

The 'pfn' returned by axonram was completely bogus, and has been since
2008.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 arch/powerpc/sysdev/axonram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ad56edc..e8bb33b 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -156,7 +156,7 @@ axon_ram_direct_access(struct block_device *device, sector_t sector,
 	}
 
 	*kaddr = (void *)(bank->ph_addr + offset);
-	*pfn = virt_to_phys(kaddr) >> PAGE_SHIFT;
+	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
 
 	return 0;
 }
-- 
1.9.3


