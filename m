Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3HBIdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:33:38 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:38389 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3HBIdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:33:36 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH v3 0/2] usb: gadget: at91_udc: add usb_clk for transition to common clk framework
Date: Fri,  2 Aug 2013 10:33:28 +0200
Message-Id: <1375432408-28371-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8060317434766391493
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series prepare the at91 SoCs transition to common clk framework.
This is done by adding a new clock (called usb clock or uclk) to at91_udc
driver. This clock will be used to configure the usb port clock rate.

Best Regards,

Boris

Changes since v2:
- split the patch in 2 parts:
    * add missing clk_put for existing clk (fclk and uclk)
    * add usb clock (uclk) support

Changes since v1:
- use IS_ENABLED(CONFIG_COMMON_CLK) to isolate new at91 clk support  

Boris BREZILLON (2):
  usb: gadget: at91_udc: add missing clk_put on fclk and iclk
  usb: gadget: at91_udc: add usb_clk for transition to common clk
    framework

 drivers/usb/gadget/at91_udc.c |   21 +++++++++++++++++++--
 drivers/usb/gadget/at91_udc.h |    2 +-
 2 files changed, 20 insertions(+), 3 deletions(-)

-- 
1.7.9.5

