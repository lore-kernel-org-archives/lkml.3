Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3K0Oxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:53:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3K0Oxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:53:54 -0500
Date: Wed, 27 Nov 2013 15:53:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1311271549530.14638@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive



- fix compat ioctl leak in uhid, by David Herrmann
- fix scheduling in atomic context (causing actual lockups in real world) 
  in hid-sony driver, by Sven Eckelmann
- revert patch introducing VID/PID conflict, by Jiri Kosina
- support from various new device IDs by Benjamin Tissoires and KaiChung 
  Cheng


Thanks!


Benjamin Tissoires (3):
      HID: appleir: force input to be set
      HID: kye: Add report fixup for Genius Manticore Keyboard
      HID: kye: fix unresponsive keyboard

David Herrmann (1):
      HID: uhid: fix leak for 64/32 UHID_CREATE

Jiri Kosina (1):
      Revert "HID: wiimote: add LEGO-wiimote VID"

KaiChung Cheng (1):
      HID: multicouh: add PID VID to support 1 new Wistron optical touch device

Sven Eckelmann (1):
      HID: sony: Send FF commands in non-atomic context

 drivers/hid/Kconfig            |    1 +
 drivers/hid/hid-appleir.c      |    3 ++
 drivers/hid/hid-core.c         |    2 +-
 drivers/hid/hid-ids.h          |    5 +++-
 drivers/hid/hid-kye.c          |   13 ++++++++++
 drivers/hid/hid-multitouch.c   |    6 ++++
 drivers/hid/hid-sony.c         |   53 +++++++++++++++++++++++++++++++--------
 drivers/hid/hid-wiimote-core.c |    5 +---
 drivers/hid/uhid.c             |    2 +-
 9 files changed, 72 insertions(+), 18 deletions(-)

-- 
Jiri Kosina
SUSE Labs
