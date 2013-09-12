Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3ILOTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48882 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3ILOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:20 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-35-5231cd66ccaa
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/6] usb: s3c-hsotg: fixes for proper functioning
Date: Thu, 12 Sep 2013 16:18:46 +0200
Message-id: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd20s4ZBBleW6VtsnLGe1eLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHhzeye7A7rF/7hp2j74tqxg9jt/YzuTxeZNcAEsUl01K
	ak5mWWqRvl0CV8b2jdkFL9grGp/bNTBuZuti5OSQEDCRuLb9LpQtJnHh3nogm4tDSGA6o8SZ
	ZU9YIJwuJomOBddYQarYBHQktnyfwAhiiwgISKx/cYkdpIhZYDujxJP/XUAJDg5hAUeJrndu
	IDUsAqoS56YtBwvzCrhKTDzqCrFMXuLp/T6wxbwCghI/Jt9jAbGZBdQlJs1bxAxhy0scvPKc
	ZQIj3ywkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCQPpPewbiqweIQ
	owAHoxIPb+JiwyAh1sSy4srcQ4wSHMxKIryfJwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5s
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1ME4OMD2wPLNk4fvtF+I8uFZeqwh+uvDxo48vO2aXWUz1
	UfF73+sTXKka8PeVpkLSckmHz1Miz67YFP3WZ6vwnYspXpWizS3yL/TybExVv3wrYIoWfct7
	+gjna9fDzEorpv5OWnNIIIy7znixelKoceNO2eim3dUf0xREXy762CbnwHL1TUDJByWW4oxE
	Qy3mouJEAGtzPHNOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add few fixes:
- remove unneeded disconnect from ErlySusp interrupt handling
- remove deprecated driver dependency CONFIG_S3C_DEV_USB_HSOTG
- fix driver unregistration function
- fix "protocol stall" handling, by enqueue new ep0 request when stalled
- add correct interrput handling in dedicated-fifos mode
- fix endpoint halt clearing, when it is not currently halted

Chanho Park (1):
  usb: s3c-hsotg: do not disconnect gadget when receiving ErlySusp intr

Marek Szyprowski (2):
  usb: s3c-hsotg: change dependency to PLAT_SAMSUNG
  usb: s3c-hsotg: fix unregistration function

Robert Baldyga (3):
  USB: gadget: s3c-hsotg: fix "protocol stall" handling
  USB: gadget: s3c-hsotg: fix dedicated fifos handling
  USB: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT

 drivers/usb/gadget/Kconfig     |    2 +-
 drivers/usb/gadget/s3c-hsotg.c |   81 +++++++++++++++++++++++++++-------------
 2 files changed, 56 insertions(+), 27 deletions(-)

-- 
1.7.9.5

