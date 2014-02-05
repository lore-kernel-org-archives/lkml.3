Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaBET3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:29:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:32570 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaBET3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:29:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,788,1384329600"; 
   d="scan'208";a="476566552"
From: ville.syrjala@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 0/3] x86: Intel gen2 graphics stolen memory quirks
Date: Wed,  5 Feb 2014 21:28:57 +0200
Message-Id: <1391628540-23072-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Ingo asked me to post the x86 bits as a standalone series. So here it is.

So the series adds the Intel gen2 graphics stolen memory reservation quirks
to arch/x86. These are not unlike the quirks we have for later gens, except
it's a bit more work to dig out the correct range to reserve on gen2.

This has been tested on 830, 845 and 855 chipsets. 865 still eludes me
unfortunately.

Ville Syrjälä (3):
  x86: Add vfunc for Intel graphics stolen memory base address
  x86: Add Intel graphics stolen memory quirk for gen2 platforms
  x86: Print the Intel graphcis stolen memory range

 arch/x86/kernel/early-quirks.c | 211 +++++++++++++++++++++++++++++++++++------
 include/drm/i915_drm.h         |  20 ++++
 2 files changed, 202 insertions(+), 29 deletions(-)

-- 
1.8.3.2

