Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbbATAZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:25:15 -0500
Received: from hofr.at ([212.69.189.236]:37738 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbATAZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:25:13 -0500
Date: Tue, 20 Jan 2015 01:25:11 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "Koenig, Christian" <Christian.Koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/radeon: remove unreachable code
Message-ID: <20150120002511.GA19484@opentech.at>
References: <1421673040-12305-1-git-send-email-der.herr@hofr.at> <A3397C8B8B789E45844E7EC5DEAD89D0635F03CC@satlexdag05.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D0635F03CC@satlexdag05.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Deucher, Alexander wrote:

> > -----Original Message-----
> > From: Nicholas Mc Guire [mailto:der.herr@hofr.at]
> > Sent: Monday, January 19, 2015 8:11 AM
> > To: Deucher, Alexander
> > Cc: Koenig, Christian; David Airlie; dri-devel@lists.freedesktop.org; linux-
> > kernel@vger.kernel.org; Nicholas Mc Guire
> > Subject: [PATCH] drm/radeon: remove unreachable code
> > 
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> 
> NACK.  I want to leave this in place for the future.  When we support dynamically adjusting the disp clock we'll need to update the sclk for ds mode.
>

get it - then could you add some comment to that end so it becomes clear 
that this is intentional - using your comment above - something like:

 
>From 2be978edbc77d5928ede8fddc2d784ca6f78533e Mon Sep 17 00:00:00 2001
From: Nicholas Mc Guire <der.herr@hofr.at>
Date: Mon, 19 Jan 2015 19:11:57 -0500
Subject: [PATCH] document the unreachable code sequence

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/gpu/drm/radeon/ci_dpm.c                 |    7 +++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index f373a81..722dfef 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -3808,7 +3808,12 @@ static void ci_find_dpm_states_clocks_in_dpm_table(struct radeon_device *rdev,
 	if (i >= sclk_table->count) {
 		pi->need_update_smu7_dpm_table |= DPMTABLE_OD_UPDATE_SCLK;
 	} else {
-		/* XXX check display min clock requirements */
+		/*
+		 * XXX Check display min clock requirements.
+		 * This is a place holder for the future support of
+		 * dynamically adjusting the disp clock where we'll
+		 * need to update the sclk for ds mode.
+		 */
 		if (CISLAND_MINIMUM_ENGINE_CLOCK != CISLAND_MINIMUM_ENGINE_CLOCK)
 			pi->need_update_smu7_dpm_table |= DPMTABLE_UPDATE_SCLK;
 	}
-- 
1.7.10.4

