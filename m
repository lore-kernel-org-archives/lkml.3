Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab3GaNn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:43:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759719Ab3GaNZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.437149876@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [64/84] drm/radeon: improve dac adjust heuristics for legacy pdac
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 03ed8cf9b28d886c64c7e705c7bb1a365fd8fb95 upstream.

Hopefully avoid more quirks in the future due to bogus
vbios dac data.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_combios.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -953,8 +953,10 @@ struct radeon_encoder_primary_dac *radeo
 			dac = RBIOS8(dac_info + 0x3) & 0xf;
 			p_dac->ps2_pdac_adj = (bg << 8) | (dac);
 		}
-		/* if the values are all zeros, use the table */
-		if (p_dac->ps2_pdac_adj)
+		/* if the values are zeros, use the table */
+		if ((dac == 0) || (bg == 0))
+			found = 0;
+		else
 			found = 1;
 	}
 

