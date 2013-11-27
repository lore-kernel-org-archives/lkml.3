Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab3K0BAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:50 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18744 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3K0BAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:00:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Nov 2013 16:54:26 -0800
Date: Tue, 26 Nov 2013 17:00:42 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Steven Miao <realmz6@gmail.com>, Bob Liu <lliubbo@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] blackfin: bf60x: clock: return 0 upon error from
 clk_round_rate()
Message-ID: <alpine.DEB.2.02.1311261659010.11450@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clk_round_rate() should return 0 upon an error, rather than returning
a negative error code.  This is because clk_round_rate() is being
changed to return an unsigned return type rather than a signed type,
since some clock sources can generate rates higher than (2^31)-1 Hz.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
---
Applies on v3.13-rc1.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  arch/blackfin/mach-bf609/clock.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/mach-bf609/clock.c b/arch/blackfin/mach-bf609/clock.c
index dab8849af884..3f5323d3e116 100644
--- a/arch/blackfin/mach-bf609/clock.c
+++ b/arch/blackfin/mach-bf609/clock.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL(clk_get_rate);

  long clk_round_rate(struct clk *clk, unsigned long rate)
  {
-	long ret = -EIO;
+	long ret = 0;
  	if (clk->ops && clk->ops->round_rate)
  		ret = clk->ops->round_rate(clk, rate);
  	return ret;
