Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3AWQZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:25:40 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41783 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab3AWQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:25:21 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fbdev-devel@lists.sourceforge.net,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/2] fbcon+i915 locking fixes
Date: Wed, 23 Jan 2013 17:25:07 +0100
Message-Id: <1358958309-5342-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

First patch is a resend of Alan's fbcon vs. fb notifier deadlock fix.
Without this lockdep is pretty much useless for debugging drm locking
issues, and it looks like quite a few bootup hangs could be blamed on this
one, too.

Since the fbdev maintainer seems to be awol, please merge this through
your drm tree. I've looked through the patch and the new locking seems to
be sane so feel free to smash a

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

onto it.

2nd patch is a locking bug in the i915 driver with the new kms locking.
Since the bug only happens in your drm-next tree, please apply the patch
there directly.

Thanks, Daniel

Alan Cox (1):
  fb: Rework locking to fix lock ordering on takeover

Daniel Vetter (1):
  drm/i915: fixup crtc locking in intel_release_load_detect_pipe

 drivers/gpu/drm/i915/intel_display.c |    1 +
 drivers/tty/vt/vt.c                  |   81 ++++++++++++++++++++++++++--------
 drivers/video/console/fbcon.c        |   30 ++++++++++++-
 drivers/video/fbmem.c                |    5 +--
 drivers/video/fbsysfs.c              |    3 ++
 include/linux/console.h              |    1 +
 6 files changed, 98 insertions(+), 23 deletions(-)

-- 
1.7.10.4

