Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaFEAi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:38:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaFDXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>, matthias.graf@st.ovqu.de,
        bp@alien8.de
Subject: [PATCH 3.14 078/228] drm/radeon: disable dpm on rv770 by default
Date: Wed,  4 Jun 2014 16:21:47 -0700
Message-Id: <20140604232350.585404903@linuxfoundation.org>
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

commit 76e6dcece841faebbee78895780e8209ff40d922 upstream.

There seem to be stability issues on a number of cards.

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=76286
https://bugzilla.redhat.com/show_bug.cgi?id=1085785
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=741619

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: matthias.graf@st.ovqu.de
Cc: bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1240,6 +1240,7 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_RV670:
 	case CHIP_RS780:
 	case CHIP_RS880:
+	case CHIP_RV770:
 	case CHIP_BARTS:
 	case CHIP_TURKS:
 	case CHIP_CAICOS:
@@ -1256,7 +1257,6 @@ int radeon_pm_init(struct radeon_device
 		else
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
 		break;
-	case CHIP_RV770:
 	case CHIP_RV730:
 	case CHIP_RV710:
 	case CHIP_RV740:


