Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaFDXVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaFDXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 077/228] drm/radeon: dont allow runpm=1 on systems with out ATPX
Date: Wed,  4 Jun 2014 16:21:46 -0700
Message-Id: <20140604232350.550151513@linuxfoundation.org>
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

commit 73acacc7397fe854ed2ab75f1c940fa00faaf15e upstream.

vgaswitcheroo and the ATPX ACPI methods are required to
power down the dGPU.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=73901

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_kms.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -107,11 +107,9 @@ int radeon_driver_load_kms(struct drm_de
 		flags |= RADEON_IS_PCI;
 	}
 
-	if (radeon_runtime_pm == 1)
-		flags |= RADEON_IS_PX;
-	else if ((radeon_runtime_pm == -1) &&
-		 radeon_has_atpx() &&
-		 ((flags & RADEON_IS_IGP) == 0))
+	if ((radeon_runtime_pm != 0) &&
+	    radeon_has_atpx() &&
+	    ((flags & RADEON_IS_IGP) == 0))
 		flags |= RADEON_IS_PX;
 
 	/* radeon_device_init should report only fatal error


