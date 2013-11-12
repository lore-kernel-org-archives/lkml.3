Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3KLAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:16:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:47195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3KLAQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:16:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407152568"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Olof Johansson <olof@lixom.net>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFC PATCH 0/3] x86, boot: Low memory reservation fixes
Date: Mon, 11 Nov 2013 16:16:44 -0800
Message-Id: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

On all but the tiniest of modern systems, losing half a megabyte of
RAM is a small price to pay for system stability.  Thus, switch the
default for low memory reservation to 640K.  This has been possible,
but has not been the default, since v3.9, specifically checkin:

  95c9608478d6 x86, mm: Move reserving low memory later in initialization

The above checkin exposes a problem with our reservation ordering;
specifically setup_bios_corruption_check() is called too early, so fix
that.  This caused the BIOS corruption check to run on memory that
would have been reserved anyway.

Finally, change the low memory check scanner to scan 640K rather than
64K by default.  The low memory check scanner will be a noop in the
common case, as it now will only grab memory that is not otherwise
reserved; this makes it purely a diagnostic tool.

H. Peter Anvin (3):
      x86, boot: Move setup_bios_corruption_check() later
      x86, boot: Change the default for X86_RESERVE_LOW to 640K, make EXPERT
      x86, boot: Change the BIOS corruption checker to scan 640K
