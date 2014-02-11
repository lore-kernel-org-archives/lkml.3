Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaBKUIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:08:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaBKTGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 056/107] drm/radeon/dpm: disable mclk switching on desktop RV770
Date: Tue, 11 Feb 2014 11:05:22 -0800
Message-Id: <20140211184749.790157335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8097d94116d0c17e774ba4c8256e774018dc2a46 upstream.

Mclk switching doesn't seem to work reliably on these
cards.  Most RV770 boards specify the same mclk for all
performance levels anyway so in most cases, this has
no affect.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73067

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rv770_dpm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2531,6 +2531,12 @@ bool rv770_dpm_vblank_too_short(struct r
 	    (rdev->pdev->subsystem_device == 0x1c42))
 		switch_limit = 200;
 
+	/* RV770 */
+	/* mclk switching doesn't seem to work reliably on desktop RV770s */
+	if ((rdev->family == CHIP_RV770) &&
+	    !(rdev->flags & RADEON_IS_MOBILITY))
+		switch_limit = 0xffffffff; /* disable mclk switching */
+
 	if (vblank_time < switch_limit)
 		return true;
 	else


