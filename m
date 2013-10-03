Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3JCEOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:14:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3JCEOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:14:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Dieter=20N=C3=BCtzel?= <Dieter@nuetzel-hh.de>
Subject: [ 44/52] drm/radeon: avoid UVD corruption on AGP cards using GPU gart
Date: Wed,  2 Oct 2013 21:06:02 -0700
Message-Id: <20131003040525.248314352@linuxfoundation.org>
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

commit 4ca5a6cba53e13b8fd153b0762b4128fab6a3cfb upstream.

If the user has forced the driver to use the internal GPU gart
rather than AGP on an AGP card, force the buffers to vram
as well.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Dieter Nützel <Dieter@nuetzel-hh.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -84,7 +84,7 @@ static int radeon_cs_parser_relocs(struc
 		   VRAM, also but everything into VRAM on AGP cards to avoid
 		   image corruptions */
 		if (p->ring == R600_RING_TYPE_UVD_INDEX &&
-		    (i == 0 || p->rdev->flags & RADEON_IS_AGP)) {
+		    (i == 0 || drm_pci_device_is_agp(p->rdev->ddev))) {
 			/* TODO: is this still needed for NI+ ? */
 			p->relocs[i].lobj.domain =
 				RADEON_GEM_DOMAIN_VRAM;


