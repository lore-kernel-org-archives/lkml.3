Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057Ab3JPUfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:35:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761668Ab3JPUfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:35:13 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: daniel.vetter@ffwll.ch
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, przanoni@gmail.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [v3.10][v3.11][v3.12][Regression][PATCH 0/1] Revert "Revert "drm/i915: revert eDP bpp clamping code changes""
Date: Wed, 16 Oct 2013 16:34:56 -0400
Message-Id: <cover.1381939165.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

A bug was opened against the Ubuntu kernel[0].  It was found that reverting the following commit resolved this bug:

commit 657445fe8660100ad174600ebfa61536392b7624
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat May 4 10:09:18 2013 +0200

    Revert "drm/i915: revert eDP bpp clamping code changes"


The regression was introduced as of v3.10-rc2 and affects a large number of end users.

I see this code has gone back and forth a few times, so I was wondering if we could get some feedback.  The revert of commit 657445f was tested aginst 3.11 stable and could not be done cleanly, so I had to make some modifications.  The modifications I made for 3.11 are in [PATCH 1/1].  The revert can't be done cleanly against 3.12 neither.  The modifications I made for 3.11 will not work cleanly on 3.12 due to recent changes in 3.12, such as commit 7984211.  However, I can create a patch specific for 3.12 if you think this is the best way to go. 

    
Thanks,
    
Joe 

http://pad.lv/1195483


Joseph Salisbury (1):
  Revert "Revert "drm/i915: revert eDP bpp clamping code changes""

 drivers/gpu/drm/i915/intel_dp.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

-- 
1.7.9.5

