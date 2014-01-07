Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbaAGJ6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:58:40 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40000 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaAGJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:58:37 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/4] Get EDID late for VGA switcheroo
Date: Tue,  7 Jan 2014 15:28:39 +0530
Message-Id: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

VGA switcheroo doesn't work on my 2013 MBP, and I'm trying to fix
it. From what I've gathered from previous patches, it seems that the
EDID is not computed at boottime, because LVDS isn't connected to the
i915 card (and is connected to the nouveau card instead). So, here's a
series to get switcheroo-reprobe to call get-edid. I think it's a step
in the right direction, although I think more stuff is required to fix
the issue.

Disclaimer: The series might be utter rubbish, because this is my
first attempt at any driver code.

Thanks.

Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>

Ramkumar Ramachandra (4):
  drm/i915: add support for vga_switcheroo reprobe
  drm/i915: factor out intel_lvds_get_edid()
  drm/i915: prepare intel_lvds_get_edid() for multiple calls
  drm/i915: check LVDS for EDID on GPU switches

 drivers/gpu/drm/i915/i915_dma.c   |   9 ++-
 drivers/gpu/drm/i915/i915_drv.h   |   1 +
 drivers/gpu/drm/i915/intel_drv.h  |   1 +
 drivers/gpu/drm/i915/intel_lvds.c | 112 +++++++++++++++++++++++---------------
 4 files changed, 78 insertions(+), 45 deletions(-)

-- 
1.8.5.2.229.g4448466

