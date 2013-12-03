Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3LCS3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:29:33 -0500
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:54465 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667Ab3LCS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:29:28 -0500
X-Greylist: delayed 15673 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 13:29:28 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v2 0/4] usb: ohci-at91: various fixes and improvements
Date: Tue,  3 Dec 2013 18:51:52 +0100
Message-Id: <1386093116-26387-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 2004101834387060991
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series fixes a bug detected in 3.13-rc1 caused by a wrong
assumption on platform device resources order in the platform device
resource table.

It also move the different driver resources (clks and iomem) retrieval
to the device managed versions (devm_ functions).

Best Regards,

Boris

Changes since v1:
 - split PATCH 3 in 2 different patches: one to remove references to
   &pdev->dev, the other to make use of devm_clk_get
 - replace forgotten &pdev->dev references in usb_hcd_at91_probe

Boris BREZILLON (4):
  usb: ohci-at91: fix irq and iomem resource retrieval
  usb: ohci-at91: replace request_mem_region + ioremap by
    devm_request_and_ioremap
  usb: ohci-at91: use dev variable instead of &pdev->dev
  usb: ohci-at91: use device managed clk retrieval

 drivers/usb/host/ohci-at91.c |   83 ++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 55 deletions(-)

-- 
1.7.9.5

