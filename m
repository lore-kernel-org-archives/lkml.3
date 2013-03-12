Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab3CLXGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:06:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab3CLWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 053/100] drm/i915: Fix Haswell/CRW PCI IDs.
Date: Tue, 12 Mar 2013 15:31:38 -0700
Message-Id: <20130312223128.698052792@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Graunke <kenneth@whitecape.org>

commit 86c268ed0f9b3b4d51d81dd8fcec533a164414d1 upstream.

The second digit was off by one, which meant we accidentally treated
GT(n) as GT(n-1).  This also meant no support for GT1 at all.

Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -377,15 +377,15 @@ static const struct pci_device_id pciidl
 	INTEL_VGA_DEVICE(0x0A06, &intel_haswell_m_info), /* ULT GT1 mobile */
 	INTEL_VGA_DEVICE(0x0A16, &intel_haswell_m_info), /* ULT GT2 mobile */
 	INTEL_VGA_DEVICE(0x0A26, &intel_haswell_m_info), /* ULT GT2 mobile */
-	INTEL_VGA_DEVICE(0x0D12, &intel_haswell_d_info), /* CRW GT1 desktop */
+	INTEL_VGA_DEVICE(0x0D02, &intel_haswell_d_info), /* CRW GT1 desktop */
+	INTEL_VGA_DEVICE(0x0D12, &intel_haswell_d_info), /* CRW GT2 desktop */
 	INTEL_VGA_DEVICE(0x0D22, &intel_haswell_d_info), /* CRW GT2 desktop */
-	INTEL_VGA_DEVICE(0x0D32, &intel_haswell_d_info), /* CRW GT2 desktop */
-	INTEL_VGA_DEVICE(0x0D1A, &intel_haswell_d_info), /* CRW GT1 server */
+	INTEL_VGA_DEVICE(0x0D0A, &intel_haswell_d_info), /* CRW GT1 server */
+	INTEL_VGA_DEVICE(0x0D1A, &intel_haswell_d_info), /* CRW GT2 server */
 	INTEL_VGA_DEVICE(0x0D2A, &intel_haswell_d_info), /* CRW GT2 server */
-	INTEL_VGA_DEVICE(0x0D3A, &intel_haswell_d_info), /* CRW GT2 server */
-	INTEL_VGA_DEVICE(0x0D16, &intel_haswell_m_info), /* CRW GT1 mobile */
+	INTEL_VGA_DEVICE(0x0D06, &intel_haswell_m_info), /* CRW GT1 mobile */
+	INTEL_VGA_DEVICE(0x0D16, &intel_haswell_m_info), /* CRW GT2 mobile */
 	INTEL_VGA_DEVICE(0x0D26, &intel_haswell_m_info), /* CRW GT2 mobile */
-	INTEL_VGA_DEVICE(0x0D36, &intel_haswell_m_info), /* CRW GT2 mobile */
 	INTEL_VGA_DEVICE(0x0f30, &intel_valleyview_m_info),
 	INTEL_VGA_DEVICE(0x0157, &intel_valleyview_m_info),
 	INTEL_VGA_DEVICE(0x0155, &intel_valleyview_d_info),


