Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744AbaKLDrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:47:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaKLB2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 171/319] drm/radeon: fix vm page table block size calculation
Date: Wed, 12 Nov 2014 10:15:09 +0900
Message-Id: <20141112011021.043516818@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8e66e134e20b936179ea1535dd4ed19ec4f99dba upstream.

The page offset is 12 bits.  For example if we have an
8 GB VM, we'd need 33 bits.  The number of bits needed
for PD + PT is 21 (33 - 12 or log2(8) + 18), not 20
(log2(8) + 17).

Noticed by Alexey during code review.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1130,7 +1130,7 @@ static void radeon_check_arguments(struc
 	if (radeon_vm_block_size == -1) {
 
 		/* Total bits covered by PD + PTs */
-		unsigned bits = ilog2(radeon_vm_size) + 17;
+		unsigned bits = ilog2(radeon_vm_size) + 18;
 
 		/* Make sure the PD is 4K in size up to 8GB address space.
 		   Above that split equal between PD and PTs */


