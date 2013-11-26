Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3KZAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:16:29 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13570 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3KZAQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:16:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Nov 2013 16:10:13 -0800
Date: Mon, 25 Nov 2013 16:16:27 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2] clk: clk_round_rate() should return 0, not negative
 numbers, upon error
Message-ID: <alpine.DEB.2.02.1311251603310.23090@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some clock sources can generate clock rates higher than (2^31)-1 Hz.
Currently, if these rates were returned from clk_round_rate(), they
would be considered errors according to the present function prototype
and return type.

This patch updates the documentation for clk_round_rate() to state
that it should return 0 rather than a negative error code when it
encounters an error.  The common clock framework already works this
way; however, other clock code does not yet align to this.

A future patch will modify the prototype to return unsigned values
from clk_round_rate().

This second version revises the patch description in response to
comments from Russell King.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
  include/linux/clk.h |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9a6d04524b1a..ffbbb7b2de43 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -228,7 +228,7 @@ void devm_clk_put(struct device *dev, struct clk *clk);
   * @clk: clock source
   * @rate: desired clock rate in Hz
   *
- * Returns rounded clock rate in Hz, or negative errno.
+ * Returns rounded clock rate in Hz, or 0 upon error.
   */
  long clk_round_rate(struct clk *clk, unsigned long rate);

