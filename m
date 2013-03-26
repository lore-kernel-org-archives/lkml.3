Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3CZXbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:31:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3CZWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 62/98] drm/radeon: fix S/R on VM systems (cayman/TN/SI)
Date: Tue, 26 Mar 2013 15:42:51 -0700
Message-Id: <20130326224248.949574787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fa3daf9aa74a3ac1c87d8188a43d283d06720032 upstream.

We weren't properly tearing down the VM sub-alloctor
on suspend leading to bogus VM PTs on resume.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=60439

Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c |    1 +
 drivers/gpu/drm/radeon/si.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1671,6 +1671,7 @@ int cayman_resume(struct radeon_device *
 int cayman_suspend(struct radeon_device *rdev)
 {
 	r600_audio_fini(rdev);
+	radeon_vm_manager_fini(rdev);
 	cayman_cp_enable(rdev, false);
 	cayman_dma_stop(rdev);
 	evergreen_irq_suspend(rdev);
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -4232,6 +4232,7 @@ int si_resume(struct radeon_device *rdev
 
 int si_suspend(struct radeon_device *rdev)
 {
+	radeon_vm_manager_fini(rdev);
 	si_cp_enable(rdev, false);
 	cayman_dma_stop(rdev);
 	si_irq_suspend(rdev);


