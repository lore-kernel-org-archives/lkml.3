Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaKEPLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:11:02 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42434 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754811AbaKEPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:10:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/3] input: ft5x06: Fix userspace reported maximum value
Date: Wed,  5 Nov 2014 16:07:47 +0100
Message-Id: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
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

Maxime Ripard (3):
  input: touchscreen: of: Use input_set_abs_params
  input: touchscreen: of: Register multitouch axes
  input: ft5x06: Allow to set the maximum axes value through the DT

 drivers/input/touchscreen/edt-ft5x06.c     |  5 ++++
 drivers/input/touchscreen/of_touchscreen.c | 39 ++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 10 deletions(-)

-- 
2.1.1

