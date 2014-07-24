Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbaGXSO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628AbaGXSOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:14:25 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 00/10] Input - wacom: conversion to HID driver, series 2
Date: Thu, 24 Jul 2014 14:13:55 -0400
Message-Id: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

this is the second series I told you about for wacom.ko. This series also have
a good number of removed lines of code. \o/

The first patch is Jason's one that I finally decided to take with me. His
previous submission still applied correctly even after the moving of the files
(git is definitively awesome).

The second one is a patch I sent earlier and forgot to include in the v2 of
the first series. It might have been dropped during my many rebases. So here
he is.

The rest is for one part enhancing the battery reporting system (to make it
equal to the one in hid-wacom, and even slightly better). The other part
is the actual merge of hid-wacom into wacom which gives the same user space API
for bluetooth and USB devices, fixes the pad-in-a-separate-input-dev, and
fixes the missing tools not supported in the previous implementation of
hid-wacom for Intuos 4 BT.

Hi Jason,

I took your patch through this series, I hope you don't mind,

Hi Przemo,

Normally, this series contains all the bits of hid-wacom (except the custom
LED/OLED API). Please tell me if I am missing anything and if you like the
change.

Cheers,
Benjamin


Benjamin Tissoires (9):
  Input - wacom: put a flag when the led are initialized
  Input - wacom: enhance Wireless Receiver battery reporting
  Input - wacom: use a uniq name for the battery device
  Input - wacom: register an ac power supply for wireless devices
  Input - wacom: prepare the driver to include BT devices
  Input - wacom: handle Graphire BT tablets in wacom.ko
  Input - wacom: handle Intuos 4 BT in wacom.ko
  Input - wacom: add copyright note and bump version to 2.0
  HID: remove hid-wacom Bluetooth driver

Jason Gerecke (1):
  Input - wacom: Support up to 2048 pressure levels with ISDv4

 drivers/hid/Kconfig     |  10 +-
 drivers/hid/Makefile    |   3 +-
 drivers/hid/hid-core.c  |   2 -
 drivers/hid/hid-wacom.c | 973 ------------------------------------------------
 drivers/hid/wacom.h     |  11 +
 drivers/hid/wacom_sys.c | 217 ++++++++++-
 drivers/hid/wacom_wac.c | 195 +++++++++-
 drivers/hid/wacom_wac.h |  10 +
 8 files changed, 415 insertions(+), 1006 deletions(-)
 delete mode 100644 drivers/hid/hid-wacom.c

-- 
2.0.1

