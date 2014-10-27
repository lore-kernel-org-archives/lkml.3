Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaJ0OPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:15:05 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:58042 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752912AbaJ0OPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:15:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:4321:4605:5007:6261:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: baby26_2bd63b918ed27
X-Filterd-Recvd-Size: 2179
Message-ID: <1414419297.8884.5.camel@perches.com>
Subject: [PATCH 02/11 V2] radeon: evergreen: Fix probable mask then right
 shift defect
From: Joe Perches <joe@perches.com>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Mon, 27 Oct 2014 07:14:57 -0700
In-Reply-To: <544E0D0E.6080206@daenzer.net>
References: <cover.1414387334.git.joe@perches.com>
	 <88c64cce88264069e0e1637fc874e699e5b226f6.1414387334.git.joe@perches.com>
	 <544E0D0E.6080206@daenzer.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Use the already #defined values instead of hardcoding.

Signed-off-by: Joe Perches <joe@perches.com>
---
> I think this should be NUM_SHADER_ENGINES_SHIFT?

(Joe can't type)

exactly right, thanks Michel

 drivers/gpu/drm/radeon/evergreen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index a31f1ca..a97a685 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3303,7 +3303,8 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 	rdev->config.evergreen.tile_config |=
 		((gb_addr_config & 0x30000000) >> 28) << 12;
 
-	num_shader_engines = (gb_addr_config & NUM_SHADER_ENGINES(3) >> 12) + 1;
+	num_shader_engines = ((gb_addr_config & NUM_SHADER_ENGINES_MASK)
+			      >> NUM_SHADER_ENGINES_SHIFT) + 1;
 
 	if ((rdev->family >= CHIP_CEDAR) && (rdev->family <= CHIP_HEMLOCK)) {
 		u32 efuse_straps_4;


