Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaBKUsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:48:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaBKTFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [PATCH 3.13 075/120] Revert "drm/radeon: disable CIK CP semaphores for now"
Date: Tue, 11 Feb 2014 11:05:16 -0800
Message-Id: <20140211184825.749322029@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7f4237c6dad7c959615b896d3c6c728c37943f4d upstream.

This reverts commit 99b4f25122f43210278cde17a9d100906235a074.

Semaphores work fine after further review and testing.

---
 drivers/gpu/drm/radeon/cik.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3566,8 +3566,6 @@ bool cik_semaphore_ring_emit(struct rade
 			     struct radeon_semaphore *semaphore,
 			     bool emit_wait)
 {
-/* TODO: figure out why semaphore cause lockups */
-#if 0
 	uint64_t addr = semaphore->gpu_addr;
 	unsigned sel = emit_wait ? PACKET3_SEM_SEL_WAIT : PACKET3_SEM_SEL_SIGNAL;
 
@@ -3576,9 +3574,6 @@ bool cik_semaphore_ring_emit(struct rade
 	radeon_ring_write(ring, (upper_32_bits(addr) & 0xffff) | sel);
 
 	return true;
-#else
-	return false;
-#endif
 }
 
 /**


