Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbaD2JSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:18:32 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:48256 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaD2JSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:18:30 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH v2 0/4] acerhdf/thermal: adding new models and appropriate governor
Date: Tue, 29 Apr 2014 11:17:53 +0200
Message-Id: <1398763077-5542-1-git-send-email-peter@piie.net>
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
 drivers/platform/x86/acerhdf.c  | 256 ++++++++++++++++++++++++++--------------
 drivers/thermal/Kconfig         |  10 ++
 drivers/thermal/Makefile        |   1 +
 drivers/thermal/gov_bang_bang.c | 124 +++++++++++++++++++
 drivers/thermal/thermal_core.c  |   5 +
 drivers/thermal/thermal_core.h  |   8 ++
 7 files changed, 314 insertions(+), 92 deletions(-)
 create mode 100644 drivers/thermal/gov_bang_bang.c

-- 
1.9.2

