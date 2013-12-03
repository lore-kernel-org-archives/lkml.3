Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3LCO0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:26:01 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:58189 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560Ab3LCOZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:25:57 -0500
X-Greylist: delayed 1051 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 09:25:57 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 0/3] usb: ohci-at91: various fixes and improvements
Date: Tue,  3 Dec 2013 15:07:46 +0100
Message-Id: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 16666133372690790655
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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

Boris BREZILLON (3):
  usb: ohci-at91: fix irq and iomem resource retrieval
  usb: ohci-at91: replace request_mem_region + ioremap by
    devm_request_and_ioremap
  usb: ohci-at91: use device managed clk retrieval

 drivers/usb/host/ohci-at91.c |   75 ++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)

-- 
1.7.9.5

