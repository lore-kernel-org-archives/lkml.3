Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3ISJum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:50:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35538 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3ISJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:50:40 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-97-523ac8ee6f67
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 0/7] usb: s3c-hsotg: fixes for proper functioning
Date: Thu, 19 Sep 2013 11:50:16 +0200
Message-id: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t9jQd13J6yCDI6ttbLYOGM9q8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbPDi8k92B3WP/3DXsHn1bVjF6HL+xncnj8ya5AJYoLpuU
	1JzMstQifbsEroxDnT9YCpbxVxx/eZypgXE/TxcjJ4eEgInEkQ1HWSFsMYkL99azdTFycQgJ
	TGeU6Hu0lAnCaWeSeLznKRNIFZuAjsSW7xMYQWwRAQGJ9S8usYMUMQtsZ5R48r8LLCEs4CJx
	Ycc6dhCbRUBVYvfjM8xdjBwcvAKuEqfWa4CYEgIKEnMm2Uxg5F7AyLCKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIzgwnkntYFzZYHGIUYCDUYmHN+KCZZAQa2JZcWXuIUYJDmYlEd45h6yC
	hHhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTDy3/tVeSht
	x6KmktjN/gxGGtXhzLwTA7ft/FpvbT//hIr35s+3OnKv84eJTD9+8NZWrVknxd6qGj0Rkfvw
	6Z7B/fC9oRYyJo1LOBTWtuUe2nZYc46BqyX/NPtWLbmMPRwc8/ik/R5m7My58m7hYy7pgLMa
	QnHLGtRXJes6beXfuu7Jw+kXn4oosRRnJBpqMRcVJwIAegBoqggCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a third version of set of patches fixing s3c-hsotg USB driver
functioning. From the previous vesrion there are two changes - fixed
one small mistake found in one of patches, and add new patch fixing
interrupt configuration for dedicated-fifo mode.

These patches add few fixes:
- Fix "protocol stall" handling, by enqueue new ep0 request when stalled
- Fix s3c_hsotg_write_fifo function to be usable in dedicated-fifo mode.
  Actually PTxFEmp/NPTxFEmp interrupts are enabled only in shared-fifo mode.
- Fix endpoint interrput handling, by disabling interrupts for endpoints which
  has no requests enqueued.
- Fixed DAINT register usage. Now only masked ep interrupts are handled.
- Fix "halt" property updating.
- Fix endpoint halt clearing, when it is not currently halted.
- Fix interrupt configuration in dedicated fifo mode.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v3:
- in patch 'fix clear feature ENDPOINT_HALT' fixed mistake in that logic OR
  were used instead of logic AND
- add patch setting correct interrupt configuration for dedicated-fifo mode

v2: https://lkml.org/lkml/2013/9/18/99
- splitted patches to get one fix in each patch, as Felipe Balbi suggested
- fixed typos

v1: https://lkml.org/lkml/2013/9/12/324
- initial proposal

Robert Baldyga (7):
  USB: gadget: s3c-hsotg: fix "protocol stall" handling
  USB: gadget: s3c-hsotg: fix s3c_hsotg_write_fifo function for
    dedicated fifo mode
  USB: gadget: s3c-hsotg: fix endpoint interrupts handling
  USB: gadget: s3c-hsotg: add DAINT masking
  USB: gadget: s3c-hsotg: fix "halted" property updating
  USB: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT
  USB: gadget: s3c-hsotg: fix interrupt configuration in dedicated-fifo
    mode

 drivers/usb/gadget/s3c-hsotg.c |   74 +++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
1.7.9.5

