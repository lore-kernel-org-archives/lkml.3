Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaFDXVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaFDXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 068/228] drm/radeon: disable mclk dpm on R7 260X
Date: Wed,  4 Jun 2014 16:21:37 -0700
Message-Id: <20140604232350.247206194@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 57700ad1f2f21d5d7ab7ee0e58d11b5954852434 upstream.

Setting higher mclks seems to cause stability issues
on some R7 260X boards.  Disable it for now for stability
until we find a proper fix.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75992

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -5106,6 +5106,10 @@ int ci_dpm_init(struct radeon_device *rd
 	pi->mclk_dpm_key_disabled = 0;
 	pi->pcie_dpm_key_disabled = 0;
 
+	/* mclk dpm is unstable on some R7 260X cards */
+	if (rdev->pdev->device == 0x6658)
+		pi->mclk_dpm_key_disabled = 1;
+
 	pi->caps_sclk_ds = true;
 
 	pi->mclk_strobe_mode_threshold = 40000;


