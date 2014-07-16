Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbaGPKWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:22:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17936 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbaGPKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:22:45 -0400
X-AuditID: cbfee61b-f79f86d00000144c-0d-53c652737c89
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 00/12] usb: dwc2/gadget: fix series
Date: Wed, 16 Jul 2014 12:22:18 +0200
Message-id: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e+xoG5J0LFggz2/WSxmvWxnsTh4v96i
	efF6NovLu+awWSxa1spssfbIXXaL7VOmM1k8OLyT3YHDY//cNewefVtWMXps2f+Z0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBlHD65k7XgI3fF+rsHWRoYz3F2MXJySAiYSLzeO5kNwhaT
	uHBvPZDNxSEkMJ1R4ty354wQTjuTxKI5m5hAqtgEdCS2fJ/ACGKLCAhIrH9xiR2kiFngBKNE
	x/8LYKOEBcwkfn96BVbEIqAqMbvpDDOIzSvgKnGo6SPUOjmJk8cms05g5F7AyLCKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIzhgnknvYFzVYHGIUYCDUYmHd0PI0WAh1sSy4srcQ4wSHMxK
	IrwO/seChXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTCa
	bZdOK7oYcrz6wb5HcxZ2OOmVia/NzYiSfbOkqWvf8u2Br1c5MhrlzGNk/b7WLJw5e0L0saMH
	JscbKnB90DPSP/ytuOtq/xevBSx7H4Uue95Q7q+YdLNy4zIOr9vRs9fPWzTh28/mxNOGDxYI
	/+xx3vN+h/3P12c1BWrF/yfWbtVZHvT+f3+TEktxRqKhFnNRcSIA046uVRQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains fixes for dwc2 gadget driver. It touches PHY,
FIFO configuration, initialization sequence and adds many other small fixes.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:
v2:
 - add patch usb: dwc2/gadget: avoid disabling ep0
 - fix FIFO flushing when it's assigned to endpoint dynamically
 - write to proper FIFO in s3c_hsotg_write_fifo() function
 - use real FIFO size in kill_all_requests
 - fix comment in s3c_hsotg_init_fifo() function

v1: https://lkml.org/lkml/2014/6/23/67

Andrzej Pietrasiewicz (1):
  usb: dwc2/gadget: Fix comment text

Kamil Debski (3):
  usb: dwc2/gadget: fix phy disable sequence
  usb: dwc2/gadget: fix phy initialization sequence
  usb: dwc2/gadget: move phy bus legth initialization

Marek Szyprowski (5):
  usb: dwc2/gadget: hide some not really needed debug messages
  usb: dwc2/gadget: ensure that all fifos have correct memory buffers
  usb: dwc2/gadget: break infinite loop in endpoint disable code
  usb: dwc2/gadget: do not call disconnect method in pullup
  usb: dwc2/gadget: delay enabling irq once hardware is configured
    properly

Robert Baldyga (3):
  usb: dwc2/gadget: assign TX FIFO dynamically
  usb: dwc2/gadget: disable clock when it's not needed
  usb: dwc2/gadget: avoid disabling ep0

 drivers/usb/dwc2/core.h   |   3 +
 drivers/usb/dwc2/gadget.c | 183 +++++++++++++++++++++++++++-------------------
 2 files changed, 109 insertions(+), 77 deletions(-)

-- 
1.9.1

