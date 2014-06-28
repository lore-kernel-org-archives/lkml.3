Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbaF1SG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:06:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaF1Rwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Pekon Gupta <pekon@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.15 079/139] ARM: OMAP2+: gpmc: enable BCH_HW ecc-scheme for AM43xx platforms
Date: Sat, 28 Jun 2014 10:47:20 -0700
Message-Id: <20140628174609.026217224@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

commit 2e091d13e65d26f21159323b95b426e5bc42670c upstream.

Fixes: commit 0611c41934ab35ce84dea34ab291897ad3cbc7be
ARM: OMAP2+: gpmc: update gpmc_hwecc_bch_capable() for new platforms and ECC schemes

Though the commit log of above commit mentions AM43xx platforms, but code change
missed AM43xx. This patch adds AM43xx to list of those SoC which have built-in
ELM hardware engine, so that BCH ecc-schemes with hardware error-correction can
be enabled on AM43xx devices.

Reported-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/gpmc-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -46,7 +46,7 @@ static struct platform_device gpmc_nand_
 static bool gpmc_hwecc_bch_capable(enum omap_ecc ecc_opt)
 {
 	/* platforms which support all ECC schemes */
-	if (soc_is_am33xx() || cpu_is_omap44xx() ||
+	if (soc_is_am33xx() || soc_is_am43xx() || cpu_is_omap44xx() ||
 		 soc_is_omap54xx() || soc_is_dra7xx())
 		return 1;
 


