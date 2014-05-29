Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaE2EfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbaE2EfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 3.14 060/140] drm/radeon: call drm_edid_to_eld when we update the edid
Date: Wed, 28 May 2014 21:33:19 -0700
Message-Id: <20140529043057.194102759@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 16086279353cbfecbb3ead474072dced17b97ddc upstream.

This needs to be done to update some of the fields in
the connector structure used by the audio code.

Noticed by several users on irc.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -792,6 +792,7 @@ int radeon_ddc_get_modes(struct radeon_c
 	if (radeon_connector->edid) {
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
+		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);
 		return ret;
 	}
 	drm_mode_connector_update_edid_property(&radeon_connector->base, NULL);


