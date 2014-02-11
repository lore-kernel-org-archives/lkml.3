Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaBKTHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaBKTHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.12 094/107] drm/mgag200: fix typo causing bw limits to be ignored on some chips
Date: Tue, 11 Feb 2014 11:06:00 -0800
Message-Id: <20140211184750.877186573@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit ec22b4aa993abbd18f5bbbcb20a1c56be3b1d38b upstream.

mode->mdev otherwise the bw limits never kick in.

Reported in RHEL testing.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_mode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1521,11 +1521,11 @@ static int mga_vga_mode_valid(struct drm
 		(mga_vga_calculate_mode_bandwidth(mode, bpp)
 			> (32700 * 1024))) {
 		return MODE_BANDWIDTH;
-	} else if (mode->type == G200_EH &&
+	} else if (mdev->type == G200_EH &&
 		(mga_vga_calculate_mode_bandwidth(mode, bpp)
 			> (37500 * 1024))) {
 		return MODE_BANDWIDTH;
-	} else if (mode->type == G200_ER &&
+	} else if (mdev->type == G200_ER &&
 		(mga_vga_calculate_mode_bandwidth(mode,
 			bpp) > (55000 * 1024))) {
 		return MODE_BANDWIDTH;


