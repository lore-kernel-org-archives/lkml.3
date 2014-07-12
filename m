Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaGLQoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:44:19 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:34667 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbaGLQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:44:17 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com, olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] media: prevent driver device access in disconnect path
Date: Sat, 12 Jul 2014 10:44:11 -0600
Message-Id: <cover.1405179280.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fe drivers attempt to access the device for power control from
their release routines. When release routines are called after device
is disconnected, the attempts fail. fe drivers should avoid accessing
the device, from their release interfaces when called from disconnect
path. The problem is noticed in drx39xyj driver. 

This patch series does the following to fix the problem:
- exports dvb-frontend exit flag by moving it from fepriv to fe.
- changes em28xx-dvb to update the fe exit path in its usb
  disconnect path
- changes drx39xyj driver to check and avoid accessing the device in
  its release interface.
 
 
Shuah Khan (3):
  media: dvb-core move fe exit flag from fepriv to fe for driver access
  media: em28xx-dvb update fe exit flag to indicate device disconnect
  media: drx39xyj driver change to check fe exit flag from release

 drivers/media/dvb-core/dvb_frontend.c       |   26 +++++++++++---------------
 drivers/media/dvb-core/dvb_frontend.h       |    5 +++++
 drivers/media/dvb-frontends/drx39xyj/drxj.c |    4 +++-
 drivers/media/usb/em28xx/em28x-dvb.c       |    8 ++++++--
 4 files changed, 25 insertions(+), 18 deletions(-)

-- 
1.7.10.4

