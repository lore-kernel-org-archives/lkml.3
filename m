Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925Ab3LIIwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:52:31 -0500
Received: from 20.mo6.mail-out.ovh.net ([178.32.124.17]:52581 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754336Ab3LIIwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:52:30 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v5 0/3] usb: ohci-at91: various improvements
Date: Mon,  9 Dec 2013 09:51:52 +0100
Message-Id: <1386579115-4324-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 9587882132975941887
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series moves the different driver resources (clks and iomem)
retrieval to the device managed versions (devm_ functions).

Best Regards,

Boris

Changes since v4:
 - remove unneeded debug trace in case devm_ioremap_resource fails
   (an error message is already printed within this function)

Changes since v3:
 - replace devm_request_and_ioremap call by devm_ioremap_resource

Changes since v2:
 - split urgent fix and resource retrieval improvements

Boris BREZILLON (3):
  usb: ohci-at91: replace request_mem_region + ioremap by
    devm_ioremap_resource
  usb: ohci-at91: use dev variable instead of &pdev->dev
  usb: ohci-at91: use device managed clk retrieval

 drivers/usb/host/ohci-at91.c |   67 ++++++++++++------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

-- 
1.7.9.5

