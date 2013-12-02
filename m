Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3LBUit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:38:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3LBTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 138/173] drm/radeon/vm: dont attempt to update ptes if ib allocation fails
Date: Mon,  2 Dec 2013 11:12:01 -0800
Message-Id: <20131202191159.268890617@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4cc948b94a222c310ae089c36718aac7a03aec90 upstream.

If we fail to allocate an indirect buffer (ib) when updating
the ptes, return an error instead of trying to use the ib.
Avoids a null pointer dereference.

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=58621

v2 (chk): rebased on drm-fixes-3.12 for stable inclusion

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_gart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -1157,6 +1157,8 @@ int radeon_vm_bo_update_pte(struct radeo
 		return -ENOMEM;
 
 	r = radeon_ib_get(rdev, ridx, &ib, NULL, ndw * 4);
+	if (r)
+		return r;
 	ib.length_dw = 0;
 
 	r = radeon_vm_update_pdes(rdev, vm, &ib, bo_va->soffset, bo_va->eoffset);


