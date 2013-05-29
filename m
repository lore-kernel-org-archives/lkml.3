Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583Ab3E2K1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:27:50 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10706 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412Ab3E2K1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:27:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 May 2013 03:27:35 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 1/7] gpu: host1x: Check INCR opcode correctly
Date: Wed, 29 May 2013 13:26:02 +0300
Message-ID: <1369823168-5396-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Terje Bergstrom <tbergstrom@nvidia.com>

The firewall code used a wrong loop condition (pointer to a
structure) while checking INCR opcode. This patch fixes the code to
use correct loop condition (number of words remaining).

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/job.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index f665d67..2974ac8 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -330,7 +330,7 @@ static int check_incr(struct host1x_firewall *fw)
 	u32 count = fw->count;
 	u32 reg = fw->reg;
 
-	while (fw) {
+	while (count) {
 		if (fw->words == 0)
 			return -EINVAL;
 
-- 
1.8.1.5

