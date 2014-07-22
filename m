Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaGVPhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:37:23 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:53607 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGVPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:37:20 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>
Subject: [PATCH v5 0/6] acerhdf/thermal: adding new models, appropriate governor and minor clean up 
Date: Tue, 22 Jul 2014 17:37:10 +0200
Message-Id: <1406043436-17068-1-git-send-email-peter@piie.net>
X-Mailer: git-send-email 2.0.2
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

Peter Feuerer (6):
  acerhdf: Adding support for "manual mode"
  acerhdf: Adding support for new models
  thermal: Added Bang-bang thermal governor
  acerhdf: Use bang-bang thermal governor
  acerhdf: added critical trip point
  acerhdf: minor clean up

 drivers/platform/x86/Kconfig    |   3 +-
 drivers/platform/x86/acerhdf.c  | 265 ++++++++++++++++++++++++++--------------
 drivers/thermal/Kconfig         |  10 ++
 drivers/thermal/Makefile        |   1 +
 drivers/thermal/gov_bang_bang.c | 131 ++++++++++++++++++++
 drivers/thermal/thermal_core.c  |   5 +
 drivers/thermal/thermal_core.h  |   8 ++
 7 files changed, 327 insertions(+), 96 deletions(-)
 create mode 100644 drivers/thermal/gov_bang_bang.c

-- 
2.0.2

