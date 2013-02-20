Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3BTIgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:36:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56627 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3BTIgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:36:01 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Subject: [PATCH 0/3] leds: move LED triggers and add new LED trigger for
 camera
Thread-Topic: [PATCH 0/3] leds: move LED triggers and add new LED trigger
 for camera
Thread-Index: Ac4PRUyDTaI7/+rpT+mmztPAJWKgXQ==
Date: Wed, 20 Feb 2013 08:35:56 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F79273666@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set consists of major changes below.
  (a) Move trigger drivers into new subdirectory, 'drivers/leds/trigger/'
  (b) Add LED trigger for camera functions: 'flash' and 'torch'
  (c) Support camera LED trigger feature in existing drivers: LM355x and LM3642

Milo(Woogyom) Kim (3):
  leds: move LED trigger drivers into new subdirectory
  leds: add LED Trigger for camera function
  leds: lm355x, lm3642: support Camera LED triggers for flash/torch

 drivers/leds/Kconfig                      |  101 +-----------
 drivers/leds/Makefile                     |   10 +-
 drivers/leds/leds-lm355x.c                |    2 +
 drivers/leds/leds-lm3642.c                |    2 +
 drivers/leds/ledtrig-backlight.c          |  166 -------------------
 drivers/leds/ledtrig-cpu.c                |  142 ----------------
 drivers/leds/ledtrig-default-on.c         |   45 -----
 drivers/leds/ledtrig-gpio.c               |  253 -----------------------------
 drivers/leds/ledtrig-heartbeat.c          |  161 ------------------
 drivers/leds/ledtrig-ide-disk.c           |   47 ------
 drivers/leds/ledtrig-oneshot.c            |  204 -----------------------
 drivers/leds/ledtrig-timer.c              |  131 ---------------
 drivers/leds/ledtrig-transient.c          |  237 ---------------------------
 drivers/leds/trigger/Kconfig              |  111 +++++++++++++
 drivers/leds/trigger/Makefile             |   10 ++
 drivers/leds/trigger/ledtrig-backlight.c  |  166 +++++++++++++++++++
 drivers/leds/trigger/ledtrig-camera.c     |   57 +++++++
 drivers/leds/trigger/ledtrig-cpu.c        |  142 ++++++++++++++++
 drivers/leds/trigger/ledtrig-default-on.c |   45 +++++
 drivers/leds/trigger/ledtrig-gpio.c       |  253 +++++++++++++++++++++++++++++
 drivers/leds/trigger/ledtrig-heartbeat.c  |  161 ++++++++++++++++++
 drivers/leds/trigger/ledtrig-ide-disk.c   |   47 ++++++
 drivers/leds/trigger/ledtrig-oneshot.c    |  204 +++++++++++++++++++++++
 drivers/leds/trigger/ledtrig-timer.c      |  130 +++++++++++++++
 drivers/leds/trigger/ledtrig-transient.c  |  237 +++++++++++++++++++++++++++
 include/linux/leds.h                      |    8 +
 26 files changed, 1577 insertions(+), 1495 deletions(-)
 delete mode 100644 drivers/leds/ledtrig-backlight.c
 delete mode 100644 drivers/leds/ledtrig-cpu.c
 delete mode 100644 drivers/leds/ledtrig-default-on.c
 delete mode 100644 drivers/leds/ledtrig-gpio.c
 delete mode 100644 drivers/leds/ledtrig-heartbeat.c
 delete mode 100644 drivers/leds/ledtrig-ide-disk.c
 delete mode 100644 drivers/leds/ledtrig-oneshot.c
 delete mode 100644 drivers/leds/ledtrig-timer.c
 delete mode 100644 drivers/leds/ledtrig-transient.c
 create mode 100644 drivers/leds/trigger/Kconfig
 create mode 100644 drivers/leds/trigger/Makefile
 create mode 100644 drivers/leds/trigger/ledtrig-backlight.c
 create mode 100644 drivers/leds/trigger/ledtrig-camera.c
 create mode 100644 drivers/leds/trigger/ledtrig-cpu.c
 create mode 100644 drivers/leds/trigger/ledtrig-default-on.c
 create mode 100644 drivers/leds/trigger/ledtrig-gpio.c
 create mode 100644 drivers/leds/trigger/ledtrig-heartbeat.c
 create mode 100644 drivers/leds/trigger/ledtrig-ide-disk.c
 create mode 100644 drivers/leds/trigger/ledtrig-oneshot.c
 create mode 100644 drivers/leds/trigger/ledtrig-timer.c
 create mode 100644 drivers/leds/trigger/ledtrig-transient.c

-- 
1.7.9.5


Best Regards,
Milo


