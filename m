Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbbA2Dom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:44:42 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:59062 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbbA2BZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:39 -0500
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: andrzej.p@samsung.com
Subject: [PATCH 0/2] usb/gadget: independent registration of gadgets and gadget
Date: Thu, 29 Jan 2015 03:25:32 +0200
Message-Id: <1422494734-9499-1-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds independent registration of gadgets
and gadget drivers to udc-core. This is very useful for
built-in modules into kernel case since it's possible
situation that gadget driver is probing at a time
when no gadgets are registered in udc-core.
In this case instead of silently failing without
of any attempt to recover, with independent registration
of gadgets and gadget drivers there is no matter
in which order gadgets and gadget drivers are
probed/registered.
Also it's possible to add/remove gadgets or gadget
drivers many times since it's now correctly handled
by the udc-core

This patch has side-effect on gadget drivers that had
__init/__exit attributes on some paths like bind/unbind
and (since bind/unbind may happen at any time) should
not use them now. This is covered by second patch
(please let me know if I need to break it into separate
patches for each gadget driver)

Ruslan Bilovol (2):
  usb: gadget: udc-core: independent registration of gadgets and gadget
    drivers
  usb: gadget: legacy: don't use __init/__exit attributes for
    bind/unbind path

 drivers/usb/gadget/legacy/acm_ms.c       |   6 +-
 drivers/usb/gadget/legacy/audio.c        |   6 +-
 drivers/usb/gadget/legacy/cdc2.c         |   6 +-
 drivers/usb/gadget/legacy/dbgp.c         |   2 +-
 drivers/usb/gadget/legacy/ether.c        |   8 +--
 drivers/usb/gadget/legacy/gmidi.c        |   6 +-
 drivers/usb/gadget/legacy/hid.c          |   6 +-
 drivers/usb/gadget/legacy/mass_storage.c |   4 +-
 drivers/usb/gadget/legacy/multi.c        |  16 ++---
 drivers/usb/gadget/legacy/ncm.c          |   6 +-
 drivers/usb/gadget/legacy/nokia.c        |   6 +-
 drivers/usb/gadget/legacy/printer.c      |   6 +-
 drivers/usb/gadget/legacy/serial.c       |   2 +-
 drivers/usb/gadget/legacy/webcam.c       |   4 +-
 drivers/usb/gadget/legacy/zero.c         |   2 +-
 drivers/usb/gadget/udc/udc-core.c        | 112 ++++++++++++++++++++++++++++---
 16 files changed, 147 insertions(+), 51 deletions(-)

-- 
1.9.1

