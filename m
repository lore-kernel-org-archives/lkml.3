Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3HOWhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab3HOWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:37:49 -0400
Subject: [PATCH 0/2] vgaarb: Fixes for partial VGA opt-out
To: linux-kernel@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: airlied@redhat.com, intel-gfx@lists.freedesktop.org,
        ville.syrjala@linux.intel.com
Date: Thu, 15 Aug 2013 16:37:47 -0600
Message-ID: <20130815222835.27642.15330.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to add support for VGA arbitration on newer Intel graphics
devices.  The existing code attempts to do this, but appear to have
not been updated since GMCH devices roamed the Earth.  On newer
devices like Haswell, we can disable VGA memory through an MSR on the
device, but we rely on the VGA arbiter to manage VGA IO using the PCI
COMMAND register.  In trying to unregister legacy VGA memory, I found
that the VGA arbiter still wanted to disable both memory and IO on
the device and that it forgot to actually program the device to
disable IO when the decoding is updated.  This series attempts to fix
both of those.  Thanks,

Alex

---

Alex Williamson (2):
      vgaarb: Don't disable resources that are not owned
      vgaarb: Fix VGA decodes changes


 drivers/gpu/vga/vgaarb.c |   50 ++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)
