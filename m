Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaECSBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:01:10 -0400
Received: from smtprelay01.ispgateway.de ([80.67.29.23]:49973 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaECSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:01:08 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Zhang Rui <rui.zhang@intel.com>, Javi Merino <javi.merino@arm.com>
Subject: [PATCH v3 0/6] acerhdf/thermal: adding new models, appropriate governor and minor clean up
Date: Sat,  3 May 2014 19:59:20 +0200
Message-Id: <1399139966-10625-1-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398561815-22033-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch series is intended to:

  * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
    the fan of a few new models.

  * Add an appropriate thermal governor (Patch 3 & 4).  Manipulating and
    fiddling around with the step-wise governor has been a very fragile thing
    in the past and as it broke again, I used the opportunity to add a two
    point thermal governor which implements the actual fan handling required by
    acerhdf and puts from my point of view things straight.

  * Do some minor clean up like:
      - adding second trip point for critical temperature (Patch 5)
      - removing _t suffix from struct which isn't typedef and replace unsigned
        char by u8 (Patch 6)

Thanks and kind regards,
peter


Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Javi Merino <javi.merino@arm.com>


Peter Feuerer (6):
  acerhdf: Adding support for "manual mode"
  acerhdf: Adding support for new models
  thermal: Added Bang-bang thermal governor
  acerhdf: Use bang-bang thermal governor
  acerhdf: added critical trip point
  acerhdf: minor clean up

 drivers/platform/x86/Kconfig    |   2 +-
 drivers/platform/x86/acerhdf.c  | 260 +++++++++++++++++++++++++---------------
 drivers/thermal/Kconfig         |  10 ++
 drivers/thermal/Makefile        |   1 +
 drivers/thermal/gov_bang_bang.c | 131 ++++++++++++++++++++
 drivers/thermal/thermal_core.c  |   5 +
 drivers/thermal/thermal_core.h  |   8 ++
 7 files changed, 321 insertions(+), 96 deletions(-)
 create mode 100644 drivers/thermal/gov_bang_bang.c

-- 
1.9.2

