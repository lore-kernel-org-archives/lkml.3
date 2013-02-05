Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3BEKIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:08:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39184 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab3BEKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:08:42 -0500
Date: Tue, 5 Feb 2013 10:08:40 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: broonie@opensource.wolfsonmicro.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] extcon: arizona: Remove additional increment for jack
	flips
Message-ID: <20130205100840.GA21629@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 3aacacc..5f91711 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -722,8 +722,6 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	 * impedence then give up and report headphones.
 	 */
 	if (info->detecting && (val & 0x3f8)) {
-		info->jack_flips++;
-
 		if (info->jack_flips >= info->micd_num_modes) {
 			dev_dbg(arizona->dev, "Detected HP/line\n");
 			arizona_identify_headphone(info);
-- 
1.7.2.5

