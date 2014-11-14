Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161823AbaKNTjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:39:03 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42679 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161709AbaKNTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:38:51 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/7] Fixes for ALPS trackstick
Date: Fri, 14 Nov 2014 20:38:19 +0100
Message-Id: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix detection and identifying trackstick on machines with
ALPS devices. Last patch split trackstick and bare PS/2 mouse packets between
dev2 and dev3 input devices which make sure that driver will send only trackstick
data to trackstick input device.

Pali Rohár (7):
  input: alps: Set correct name of psmouse device in alps_init()
  input: alps: Move trackstick detection to alps_hw_init_*
  input: alps: Move alps_dolphin_get_device_area into
    alps_hw_init_dolphin_v1
  input: alps: Use NULL instead dummy argument for alps_identify
  input: alps: Fix name, product and version of dev2 input device
  input: alps: Add sanity checks for non DualPoint devices
  input: alps: Do not report both trackstick and external PS/2 mouse
    data to one input device

 drivers/input/mouse/alps.c |  361 +++++++++++++++++++++++++++++++-------------
 drivers/input/mouse/alps.h |   14 +-
 2 files changed, 264 insertions(+), 111 deletions(-)

-- 
1.7.9.5

