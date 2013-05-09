Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab3EIWtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:49:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3EIWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 61/73] drm/radeon: Always flush the VM
Date: Thu,  9 May 2013 15:32:24 -0700
Message-Id: <20130509222804.532092898@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 466476dfdcafbb4286ffa232a3a792731b9dc852 upstream.

This is slightly cleaned up version of Jerome's patch.
There seems to be an issue tracking the last flush of
the VM which results in hangs in certain cases when
VM is used.  For now just flush the VM for every IB.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62959
https://bugs.freedesktop.org/show_bug.cgi?id=62997

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -161,7 +161,8 @@ int radeon_ib_schedule(struct radeon_dev
 		radeon_semaphore_free(rdev, &ib->semaphore, NULL);
 	}
 	/* if we can't remember our last VM flush then flush now! */
-	if (ib->vm && !ib->vm->last_flush) {
+	/* XXX figure out why we have to flush for every IB */
+	if (ib->vm /*&& !ib->vm->last_flush*/) {
 		radeon_ring_vm_flush(rdev, ib->ring, ib->vm);
 	}
 	if (const_ib) {


