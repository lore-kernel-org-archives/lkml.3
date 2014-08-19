Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaHSIzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:55:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38609 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaHSIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:55:03 -0400
X-AuditID: cbfee61a-f79e46d00000134f-81-53f310e44db2
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 00/12] usb: dwc2/gadget: fix series
Date: Tue, 19 Aug 2014 10:54:06 +0200
Message-id: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xoO4Tgc/BBj33zS1mvWxnsTh4v96i
	efF6NovLu+awWSxa1spssfbIXXaLRw+3slo8OLyT3YHDY//cNewefVtWMXps2f+Z0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBltB/dy16wkKfiy+9OxgbGv5xdjJwcEgImEpe+z2KEsMUk
	Ltxbz9bFyMUhJDCdUaL310d2CKedSWLdhcNgVWwCOhJbvk8As0UE5CWub7zJAlLELHCIUeLV
	nWNMXYwcHMICthK/X6aB1LAIqEr8n76IDcTmFXCR2HtwGTvENjmJk8cms05g5F7AyLCKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIzhcnkntYFzZYHGIUYCDUYmHV+HLx2Ah1sSy4spcoKUc
	zEoivI4vPgUL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRq
	YLzguUPzmkidROncdaqi5Z8UKoNvnvy8JcnQpJnZw+XRle15Daw8EqaaURofbxUf4z8elm+w
	Pvyl/vHqz8EHdxZEzs68//LPrsVBjx69r5CUnJf7Q+VpaaDHxoWOK6ys1l4VCJl3f3ai9gV/
	dw6R5d8Y91vtW59pNetUqKMXx0tPvTz+1gytOUosxRmJhlrMRcWJADTyhEgTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I'm resending this patchset rebased on linux-next. Now it should apply.

Thanks,
Robert Baldyga

Changelog:
v3: https://lkml.org/lkml/2014/8/4/617
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

