Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3H0BJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:09:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3H0BHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 51/74] drm/radeon: fix WREG32_OR macro setting bits in a register
Date: Mon, 26 Aug 2013 18:08:49 -0700
Message-Id: <20130827010435.055955530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit d43a93c8d9bc4e0dc0293b6458c077c3c797594f upstream.

This bug (introduced in 3.10) in WREG32_OR made
commit d3418eacad403033e95e49dc14afa37c2112c134
"drm/radeon/evergreen: setup HDMI before enabling it"
cause a regression. Sometimes audio over HDMI wasn't working, sometimes
display was corrupted.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60687
https://bugzilla.kernel.org/show_bug.cgi?id=60709
https://bugs.freedesktop.org/show_bug.cgi?id=67767

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1764,7 +1764,7 @@ void r100_io_wreg(struct radeon_device *
 		WREG32(reg, tmp_);				\
 	} while (0)
 #define WREG32_AND(reg, and) WREG32_P(reg, 0, and)
-#define WREG32_OR(reg, or) WREG32_P(reg, or, ~or)
+#define WREG32_OR(reg, or) WREG32_P(reg, or, ~(or))
 #define WREG32_PLL_P(reg, val, mask)				\
 	do {							\
 		uint32_t tmp_ = RREG32_PLL(reg);		\


