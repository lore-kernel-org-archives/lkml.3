Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaD0BaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 21:30:00 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:39819 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaD0B37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 21:29:59 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Apr 2014 21:29:58 EDT
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 0/4] acerhdf/thermal: adding new models and appropriate governor
Date: Sun, 27 Apr 2014 03:23:31 +0200
Message-Id: <1398561815-22033-1-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

finally I found time, to do some work on acerhdf.

This patch series is intended to:

  * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
    the fan of a few new models.  Unfortunately this extends lines defining
    the bios table over 80 characters, but all other methods make the code
    really ugly and hard to read.  So I hope for the reason of readability it
    is ok to break this rule.

  * Add an appropriate thermal governor (Patch 3 & 4).  Manipulating and
    fiddling around with the step-wise governor has been a very fragile thing
    in the past and as it broke again, I used the opportunity to add a two
    point thermal governor which implements the actual fan handling required by
    acerhdf and puts from my point of view things straight.

Please test/review the patches and send me your comments.

Thanks and kind regards,
peter


Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>

Peter Feuerer (4):
  acerhdf: Adding support for "manual mode"
  acerhdf: Adding support for new models
  thermal: Added Bang-bang thermal governor
  acerhdf: Use bang-bang thermal governor

 drivers/platform/x86/Kconfig    |   2 +-
 drivers/platform/x86/acerhdf.c  | 246 +++++++++++++++++++++++++---------------
 drivers/thermal/Kconfig         |  10 ++
 drivers/thermal/Makefile        |   1 +
 drivers/thermal/gov_bang_bang.c | 124 ++++++++++++++++++++
 drivers/thermal/thermal_core.c  |   5 +
 drivers/thermal/thermal_core.h  |   8 ++
 7 files changed, 304 insertions(+), 92 deletions(-)
 create mode 100644 drivers/thermal/gov_bang_bang.c

-- 
1.9.2

