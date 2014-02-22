Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaBVAu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:50:28 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:43262
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbaBVAu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:27 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 0/6] media: em28xx - power management support em28xx
Date: Fri, 21 Feb 2014 17:50:12 -0700
Message-Id: <cover.1393027856.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add power management support to em28xx usb driver. This driver works in
conjunction with extensions for each of the functions on the USB device
for video/audio/dvb/remote functionality that is present on media USB
devices it supports. During suspend and resume each of these extensions
will have to do their part in suspending the components they control.

Adding suspend and resume hooks to the existing struct em28xx_ops will
enable the extensions the ability to implement suspend and resume hooks
to be called from em28xx driver. The overall approach is as follows:

-- add suspend and resume hooks to em28xx_ops
-- add suspend and resume routines to em28xx-core to invoke suspend
   and resume hooks for all registered extensions.
-- change em28xx dvb, audio, input, and video extensions to implement
   em28xx_ops: suspend and resume hooks. These hooks do what is necessary
   to suspend and resume the devices they control.

Shuah Khan (6):
  media: em28xx - add suspend/resume to em28xx_ops
  media: em28xx-audio - implement em28xx_ops: suspend/resume hooks
  media: em28xx-dvb - implement em28xx_ops: suspend/resume hooks
  media: em28xx-input - implement em28xx_ops: suspend/resume hooks
  media: em28xx-video - implement em28xx_ops: suspend/resume hooks
  media: em28xx - implement em28xx_usb_driver suspend, resume,
    reset_resume hooks

 drivers/media/usb/em28xx/em28xx-audio.c | 30 +++++++++++++++++
 drivers/media/usb/em28xx/em28xx-cards.c | 26 +++++++++++++++
 drivers/media/usb/em28xx/em28xx-core.c  | 28 ++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 57 +++++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-input.c | 35 ++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-video.c | 28 ++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  4 +++
 7 files changed, 208 insertions(+)

-- 
1.8.3.2

