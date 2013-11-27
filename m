Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3K0BEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:04:55 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18907 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3K0BEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:04:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Nov 2013 17:02:21 -0800
Date: Tue, 26 Nov 2013 17:04:18 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>
CC: <linux-c6x-dev@linux-c6x.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] C6X: clock: return 0 upon error from clk_round_rate()
Message-ID: <alpine.DEB.2.02.1311261702390.11450@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clk_round_rate() should return 0 now upon an error, rather than returning 
a negative error code.  This is because clk_round_rate() is being changed 
to return an unsigned return type rather than a signed type, since some 
clock sources can generate rates higher than (2^31)-1 Hz.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
---
Applies on v3.13-rc1.  See also:

     http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  arch/c6x/platforms/pll.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/c6x/platforms/pll.c b/arch/c6x/platforms/pll.c
index 3aa898f7ce4d..79d28dda660a 100644
--- a/arch/c6x/platforms/pll.c
+++ b/arch/c6x/platforms/pll.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(clk_get_rate);
  long clk_round_rate(struct clk *clk, unsigned long rate)
  {
  	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
+		return 0;

  	if (clk->round_rate)
  		return clk->round_rate(clk, rate);
