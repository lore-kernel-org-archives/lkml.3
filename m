Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaIJVET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:04:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64746 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaIJVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:04:17 -0400
Date: Wed, 10 Sep 2014 14:04:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.17-rc4
Message-ID: <20140910210414.GA24104@core.coreip.homeip.net>
References: <20140815061242.GA23913@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140815061242.GA23913@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get an update to
Synaptics PS/2 driver to handle "ForcePads" (currently found in HP
EliteBook 1040 laptops), a change for Elan PS/2 driver to detect newer
touchpads, bunch of devices get annotated as Trackpoint and/or Pointer
to help userspace classify and handle them, plus assorted driver fixes.

Changelog:
---------

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: add INPUT_PROP_POINTING_STICK property
      Input: add missing POINTER / DIRECT properties to a bunch of drivers

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Klaus Goger (1):
      Input: cap1106 - fix register definition

Lothar Waﬂmann (1):
      Input: matrix_keypad - use request_any_context_irq()

Masanari Iida (1):
      Input: wm971x - fix typo in module parameter description

Nick Dyer (1):
      Input: atmel_mxt_ts - downgrade warning about empty interrupts

Stephen Warren (1):
      Input: atmel_mxt_ts - fix double free of input device


Diffstat:
--------

 drivers/input/keyboard/cap1106.c         |  4 +-
 drivers/input/keyboard/matrix_keypad.c   |  9 +++--
 drivers/input/mouse/alps.c               |  4 ++
 drivers/input/mouse/elantech.c           | 11 ++++++
 drivers/input/mouse/psmouse-base.c       |  2 +
 drivers/input/mouse/synaptics.c          | 68 ++++++++++++++++++++++++--------
 drivers/input/mouse/synaptics.h          | 11 ++++++
 drivers/input/mouse/synaptics_usb.c      |  6 +++
 drivers/input/mouse/trackpoint.c         |  3 ++
 drivers/input/serio/serport.c            | 45 +++++++++++++++++----
 drivers/input/touchscreen/atmel_mxt_ts.c | 25 +++++++++---
 drivers/input/touchscreen/wm9712.c       |  2 +-
 drivers/input/touchscreen/wm9713.c       |  2 +-
 include/uapi/linux/input.h               |  1 +
 14 files changed, 156 insertions(+), 37 deletions(-)

-- 
Dmitry
