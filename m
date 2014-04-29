Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbaD2TuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:50:07 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:46685 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaD2TuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:50:05 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
        olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 0/4] Add managed token devres interfaces and change media drivers to use it 
Date: Tue, 29 Apr 2014 13:49:22 -0600
Message-Id: <cover.1398797954.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Media drivers that control a single media TV stick are a
diversified group. Analog and digital TV function drivers have
to coordinate access to their shared functions. In some cases,
snd-usb-audio is used to support audio function on media devices.

A shared managed resource framework at drivers/base level will
allow a media device to be controlled by drivers that don't
fall under drivers/media and share functions with other media
drivers.

A token devres that can be looked up by a token for locking, try
locking, unlocking will help avoid adding data structure
dependencies between various drivers. This token is a unique
string that can be constructed from a common data structure such as
struct device, bus_name, and hardware address.

This patch series adds devm_token_* interfaces to manage access to
token resource and a tuner token to allow sharing tuner function
across analog and digital functions. em28xx and dvb-core make
use of this new tuner token to control tuner access. Analog changes
will be added in a subsequent patch series.

Patch series is tested with Kworld UB435-Q V3 USB TV stick and
Kaffeine media player.

Shuah Khan (4):
  drivers/base: add managed token devres interfaces
  media: dvb-fe changes to use token for shared access control
  media/em28xx: changes to create token for tuner access
  media: em28xx dvb changes to initialze dvb fe tuner token

 drivers/base/Makefile                   |    2 +-
 drivers/base/token_devres.c             |  146 +++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.c   |   15 ++++
 drivers/media/dvb-core/dvb_frontend.h   |    1 +
 drivers/media/usb/em28xx/em28xx-cards.c |   41 +++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |    4 +
 drivers/media/usb/em28xx/em28xx.h       |    4 +
 include/linux/token_devres.h            |   19 ++++
 8 files changed, 231 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/token_devres.c
 create mode 100644 include/linux/token_devres.h

-- 
1.7.10.4

