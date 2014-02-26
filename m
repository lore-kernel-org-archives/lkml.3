Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaBZKvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaBZKvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:51:46 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kys@microsoft.com, abgupta@microsoft.com, haiyangz@microsoft.com,
        jasowang@redhat.com, tomi.valkeinen@ti.com,
        devel@linuxdriverproject.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v5 0/2] hyperv-fb: add support for generation 2 virtual machines
Date: Wed, 26 Feb 2014 11:51:23 +0100
Message-Id: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

This patch series adds support for uefi-based gen2 virtual machines
to the hyperv-fb driver.  It depends on a few vmbus changes which are
staged in Greg's char-misc tree (and linux-next).

Patch #1 implements gen2 vm support for hyperv-fb.

Patch #2 unregisters efifb early to make sure the framebuffer isn't used
any more while hyperv-fb initialization is in progress.

v5 changes:
 - call remove_conflicting_framebuffers() only on gen2
   virtual machines.

v4 changes:
 - use KBUILD_MODNAME everywhere for consistent naming.
 - drop the two patches which Greg has staged in char-misc.

please apply,
  Gerd

Gerd Hoffmann (2):
  hyperv-fb: add support for generation 2 virtual machines.
  hyperv-fb: kick off efifb early

 drivers/video/hyperv_fb.c | 88 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 26 deletions(-)

-- 
1.8.3.1

