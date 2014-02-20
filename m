Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaBUA6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:58:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaBTXvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 26/66] drm/radeon: fix UVD IRQ support on 7xx
Date: Thu, 20 Feb 2014 15:51:25 -0800
Message-Id: <20140220234910.241695776@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 858a41c853cef2cb01de34dae334c19c1c15b237 upstream.

Otherwise decoding isn't really useable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -4509,6 +4509,10 @@ restart_ih:
 				break;
 			}
 			break;
+		case 124: /* UVD */
+			DRM_DEBUG("IH: UVD int: 0x%08x\n", src_data);
+			radeon_fence_process(rdev, R600_RING_TYPE_UVD_INDEX);
+			break;
 		case 176: /* CP_INT in ring buffer */
 		case 177: /* CP_INT in IB1 */
 		case 178: /* CP_INT in IB2 */


