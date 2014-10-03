Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbaJDAob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:44:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbaJCVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bill Pringlemeir <bpringlemeir@nbsps.com>,
        Stefan Agner <stefan@agner.ch>, Shawn Guo <shawn.guo@freescale.com>
Subject: [PATCH 3.16 038/357] ARM: dts: vf610-twr: Fix pinctrl_esdhc1 pin definitions.
Date: Fri,  3 Oct 2014 14:27:04 -0700
Message-Id: <20141003212934.609635150@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bill Pringlemeir <bpringlemeir@nbsps.com>

commit 0aa4dcb5b730f5da2540926b94d98636fe7d1cbc upstream.

Previous version had an extra 'fsl' which made the pins not match
any entry.  The console message,

 vf610-pinctrl 40048000.iomuxc: no fsl,pins property in node \
    /soc/aips-bus@40000000/iomuxc@40048000/vf610-twr/esdhc1grp

is displayed without the fix.  The prior version would generally
work as u-boot sets the pins properly for sdhc.  This change allows
Linux sdhc use even if u-boot is built without sdhc support.

Signed-off-by: Bill Pringlemeir <bpringlemeir@nbsps.com>
Acked-by: Stefan Agner <stefan@agner.ch>
Fixes: 0517fe6aa880 ("ARM: dts: vf610-twr: Add support for sdhc1")
Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/vf610-twr.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -168,7 +168,7 @@
 		};
 
 		pinctrl_esdhc1: esdhc1grp {
-			fsl,fsl,pins = <
+			fsl,pins = <
 				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
 				VF610_PAD_PTA25__ESDHC1_CMD	0x31ef
 				VF610_PAD_PTA26__ESDHC1_DAT0	0x31ef


