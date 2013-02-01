Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3BAIME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:12:04 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49317 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3BAIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:03 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/10] Input: atmel_mxt_ts - make fw update more robust
Date: Fri,  1 Feb 2013 16:11:42 +0800
Message-Id: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset attempts to make the atmel fw update a bit more robust by.
Some highlights:
 1) handle more errors during fw update
 2) use the CHG (interrupt) line to detect state transitions (instead of open
    waiting)
 3) handle cases where the device is in bootloader at probe time
 4) tear down the input device before fw update and recreate on success. 

Applies cleanly to Dmitry's input/next branch.

Benson Leung (4):
  Input: atmel_mxt_ts - refactor bootloader entry/exit
  Input: atmel_mxt_ts - wait for CHG assert in mxt_check_bootloader
  Input: atmel_mxt_ts - wait for CHG after bootloader resets
  Input: atmel_mxt_ts - increase FWRESET_TIME

Daniel Kurtz (6):
  Input: atmel_mxt_ts - refactor i2c error handling
  Input: atmel_mxt_ts - register input device before request_irq
  Input: atmel_mxt_ts - refactor input device creation
  Input: atmel_mxt_ts - handle bootloader mode at probe
  Input: atmel_mxt_ts - handle errors during fw update
  Input: atmel_mxt_ts - destroy state before fw update and restore after
 drivers/input/touchscreen/atmel_mxt_ts.c | 423 ++++++++++++++++++++++---------
 1 file changed, 300 insertions(+), 123 deletions(-)

-- 
1.8.1

