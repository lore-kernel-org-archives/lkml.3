Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaESGvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:51:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19064 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaESGvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:51:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 18 May 2014 23:45:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] drm/gk20a: FB fixes
Date: Mon, 19 May 2014 15:51:06 +0900
Message-ID: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a very shameful memory leak and a compilation error due to the use of
non-exported CMA functions. The workaround for the latter is not really elegant
(replace the CMA functions by a runtime failure if we are compiled as a
module), but is temporary and still an improvement over the current situation
(compile error).

Alexandre Courbot (2):
  drm/gk20a/fb: fix huge memory leak
  drm/gk20a/fb: fix compile error whith CMA and module

 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 95 ++++++++++++++++-------
 1 file changed, 67 insertions(+), 28 deletions(-)

-- 
1.9.2

