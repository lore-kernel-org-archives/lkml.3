Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3FKUD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3FKUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Mesman <ben@bnc.nl>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 27/32] drm/i915: no lvds quirk for hp t5740
Date: Tue, 11 Jun 2013 13:03:26 -0700
Message-Id: <20130611200129.231915661@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Mesman <ben@bnc.nl>

commit 45a211d75137b1ac869a8a758a6667f15827a115 upstream.

Last year, a patch was made for the "HP t5740e Thin Client" (see
http://lists.freedesktop.org/archives/dri-devel/2012-May/023245.html).
This device reports an lvds panel, but does not really have one.

The predecessor of this device is the "hp t5740", which also does not have
an lvds panel. This patch will add the same quirk for this device.

Signed-off-by: Ben Mesman <ben@bnc.nl>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -747,10 +747,10 @@ static const struct dmi_system_id intel_
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
-		.ident = "Hewlett-Packard HP t5740e Thin Client",
+		.ident = "Hewlett-Packard HP t5740",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP t5740e Thin Client"),
+			DMI_MATCH(DMI_PRODUCT_NAME, " t5740"),
 		},
 	},
 	{


