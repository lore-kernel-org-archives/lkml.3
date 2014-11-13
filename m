Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaKMOKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:10:51 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40490 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933032AbaKMOKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:10:07 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 0/4] input: ft5x06: Fix userspace reported maximum value
Date: Thu, 13 Nov 2014 15:06:54 +0100
Message-Id: <1415887618-29844-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The current ft5x06 reports to the user-space that its maximum
coordinates are, on both X and Y, way higher than what could be
actually usable on the screen (in my case, 5759x1151 instead of
480x800).

This causes trouble on some userspace stacks that then try to re-scale
these coordinates back to the framebuffer resolution, like QT does.

Use the of_touchscreen code to find the real touchscreen limits in the
DT case, and report that to the userspace.

Thanks,
Maxime

Changes from v1:
  - Do not use input_set_abs_params anymore to avoid enabling an axis
    that was not enabled by the driver itself in of_touchscreen
  - Emit a warning when an axis is set in the DT but not enabled in
    the driver
  - Remove EV_SYN from the edt-ft5x06 driver

Maxime Ripard (4):
  input: touchscreen: of: Use input_set_abs_params
  input: touchscreen: of: Register multitouch axes
  input: ft5x06: Allow to set the maximum axes value through the DT
  input: edt-ft5x06: Remove EV_SYN event report

 drivers/input/touchscreen/edt-ft5x06.c     |  6 ++-
 drivers/input/touchscreen/of_touchscreen.c | 62 +++++++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 11 deletions(-)

-- 
2.1.1

