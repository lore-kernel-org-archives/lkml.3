Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbaGRLju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:39:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25691 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaGRLjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:39:49 -0400
X-AuditID: cbfee61b-f79f86d00000144c-e7-53c907832b3c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 00/12] usb: dwc2/gadget: fix series
Date: Fri, 18 Jul 2014 13:39:25 +0200
Message-id: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e+xgG4z+8lgg6PtQhazXrazWBy8X2/R
	vHg9m8XlXXPYLBYta2W2WHvkLrvF9inTmSweHN7J7sDhsX/uGnaPvi2rGD227P/M6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgymib8YCv4xFPxd+l1tgbG7VxdjJwcEgImEp3ND1ggbDGJ
	C/fWs3UxcnEICSxilPhz7RUzhNPOJLG68T8zSBWbgI7Elu8TGEFsEQEBifUvLrGDFDELnGCU
	6Ph/gQ0kISxgJvHz424wm0VAVeJ+/wN2EJtXwFXiw8QV7BDr5CROHpvMOoGRewEjwypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4IB5Jr2DcVWDxSFGAQ5GJR5ei5vHg4VYE8uKK3MPMUpw
	MCuJ8GbfBwrxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg
	DAvsPOr8arqQ/r9ntR4Z753e7g671+dkW/3QZK3lutncFmebTa+lakoq6J46+uG7u5d/b48E
	g8iuxD19j23fi+vX8oYa3ry1m+1r5P/msH/TRHt+HeDfZseZUvkx91n4lNLNyquWp1VGWk1y
	Pr/CbekNPV2VkupMuf3yn/zK7kn+tXo9XT1KiaU4I9FQi7moOBEAdKmnqBQCAAA=
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
v3:
 - use endpoint index instead of FIFO index for EPFIFO
 - extend patch description

v2: https://lkml.org/lkml/2014/7/16/199
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
 drivers/usb/dwc2/gadget.c | 184 +++++++++++++++++++++++++++-------------------
 2 files changed, 111 insertions(+), 76 deletions(-)

-- 
1.9.1

