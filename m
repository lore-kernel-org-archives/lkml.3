Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbbATMaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:30:18 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44134 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbATMaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:30:15 -0500
From: Olivier Sobrie <olivier@sobrie.be>
To: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Olivier Sobrie <olivier@sobrie.be>
Subject: [PATCH 00/11] hso: fix some problems with reset/disconnect path
Date: Tue, 20 Jan 2015 13:29:27 +0100
Message-Id: <1421756978-4093-1-git-send-email-olivier@sobrie.be>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches attempt to fix some problems I observed when the hso
device is disconnected or when a usb reset is queued by the hso driver
Several patches of this serie are fixing crashes or memleaks in hso.
The last patch of this serie fix a race condition occurring when multiple
usb resets are queued on an usb interface.
This serie of patches is based on v3.18.

Olivier Sobrie (11):
  hso: remove useless header file timer.h
  hso: fix crash when device disappears while serial port is open
  hso: fix memory leak when device disconnects
  hso: fix memory leak in hso_create_rfkill()
  hso: fix small indentation error
  hso: rename hso_dev into serial in hso_free_interface()
  hso: replace reset_device work by usb_queue_reset_device()
  hso: move tty_unregister outside hso_serial_common_free()
  hso: update serial_table in usb disconnect method
  hso: add missing cancel_work_sync in disconnect()
  usb: core: fix a race with usb_queue_reset_device()

 drivers/net/usb/hso.c      | 88 ++++++++++++++++++++--------------------------
 drivers/usb/core/driver.c  |  4 ++-
 drivers/usb/core/hub.c     |  4 +--
 drivers/usb/core/message.c |  4 +--
 include/linux/usb.h        |  2 +-
 5 files changed, 46 insertions(+), 56 deletions(-)

-- 
2.2.0

