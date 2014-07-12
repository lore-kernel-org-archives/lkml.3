Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaGLVLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:11:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44665 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaGLVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:10:39 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH v2 1/2] xen: Silence compiler warnings
Date: Sat, 12 Jul 2014 23:09:47 +0200
Message-Id: <1405199388-5692-2-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com>
References: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add inline keyword to silence the following compiler
warnings if xen_efi_probe() is not used:

  CC      arch/x86/xen/setup.o
In file included from arch/x86/xen/xen-ops.h:7:0,
                 from arch/x86/xen/setup.c:31:
include/xen/xen-ops.h:43:35: warning: ‘xen_efi_probe’ defined but not used [-Wunused-function]

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 include/xen/xen-ops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 771bbba..7491ee5 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -40,7 +40,7 @@ bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
 #ifdef CONFIG_XEN_EFI
 extern efi_system_table_t *xen_efi_probe(void);
 #else
-static efi_system_table_t __init *xen_efi_probe(void)
+static inline efi_system_table_t __init *xen_efi_probe(void)
 {
 	return NULL;
 }
-- 
1.7.10.4

