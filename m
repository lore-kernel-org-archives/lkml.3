Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbbAFPoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbbAFPoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:02 -0500
Date: Tue, 6 Jan 2015 17:43:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thierry Reding <treding@nvidia.com>, linux-ia64@vger.kernel.org
Subject: [PATCH v2 07/40] ia64/uaccess: fix sparse errors
Message-ID: <1420558883-10131-8-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to read bitwise types from userspace using get_user.  At the
moment this triggers sparse errors, since the value is passed through an
integer.

Fix that up using __force.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/ia64/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/uaccess.h b/arch/ia64/include/asm/uaccess.h
index 103bedc..967c312 100644
--- a/arch/ia64/include/asm/uaccess.h
+++ b/arch/ia64/include/asm/uaccess.h
@@ -197,7 +197,7 @@ extern void __get_user_unknown (void);
 		      case 8: __get_user_size(__gu_val, __gu_ptr, 8, __gu_err); break;	\
 		      default: __get_user_unknown(); break;				\
 		}									\
-	(x) = (__typeof__(*(__gu_ptr))) __gu_val;					\
+	(x) = (__force __typeof__(*(__gu_ptr))) __gu_val;				\
 	__gu_err;									\
 })
 
-- 
MST

