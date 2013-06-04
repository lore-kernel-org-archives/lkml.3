Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3FDWlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35304 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab3FDWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:44 -0400
Message-Id: <20130604172132.507832890@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 053/184] xen/bootup: allow read_tscp call for Xen PV guests.
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit cd0608e71e9757f4dae35bcfb4e88f4d1a03a8ab upstream.

The hypervisor will trap it. However without this patch,
we would crash as the .read_tscp is set to NULL. This patch
fixes it and sets it to the native_read_tscp call.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/xen/enlighten.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index d52f895..f1539ff 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -952,6 +952,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
+	.read_tscp = native_read_tscp,
+
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64
-- 
1.7.12.2.21.g234cd45.dirty



