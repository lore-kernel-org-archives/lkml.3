Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab3JCEPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:15:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3JCEO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:14:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [ 47/52] drm/radeon: add missing hdmi callbacks for rv6xx
Date: Wed,  2 Oct 2013 21:06:05 -0700
Message-Id: <20131003040525.448441201@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 99d79aa2f3b7729e7290e8bda5d0dd8b0240ec62 upstream.

When dpm was merged, I added a new asic struct for
rv6xx, but it never got properly updated when the
hdmi callbacks were added due to the two patch sets
being developed in parallel.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=69729

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_asic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -892,6 +892,8 @@ static struct radeon_asic r520_asic = {
 		.wait_for_vblank = &avivo_wait_for_vblank,
 		.set_backlight_level = &atombios_set_backlight_level,
 		.get_backlight_level = &atombios_get_backlight_level,
+		.hdmi_enable = &r600_hdmi_enable,
+		.hdmi_setmode = &r600_hdmi_setmode,
 	},
 	.copy = {
 		.blit = &r100_copy_blit,


