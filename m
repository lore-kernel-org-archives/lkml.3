Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaL3Wne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:43:34 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37161 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaL3Wnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:43:33 -0500
X-IronPort-AV: E=Sophos;i="5.07,668,1413270000"; 
   d="scan'208";a="53944297"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        "Jonathan Richardson" <jonathar@broadcom.com>
Subject: [PATCH v4 0/3] Fix bugs in kona pwm driver and pwm core
Date: Tue, 30 Dec 2014 14:43:27 -0800
Message-ID: <1419979410-7589-1-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Jonathan Richardson <jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a number of bugs in the Broadcom Kona pwm driver. It also 
fixes a bug in the pwm core where the state was incorrect on failed calls to
enable.

Changes from v3:
- Removed setting the pwm set to disabled if enable fails. This is now
  done in the pwm core.
- Removed previous change in kona_pwmc_config() that returned right away if
  the state was disabled. The loop needs to execute to ensure that the period
  and duty cycle are valid. Delaying this check to when the pwm is enabled is 
  incorrect.
- Added comments to clarify code.
- Changed commit messages to more accurately reflect the code changes.

Jonathan Richardson (3):
  pwm: kona: Fix incorrect config, disable, and polarity procedures
  pwm: kona: Remove setting default smooth type and polarity for all
    channels
  pwm: core: Set enable state properly on failed call to enable

 drivers/pwm/core.c         |   10 +++-
 drivers/pwm/pwm-bcm-kona.c |  116 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 104 insertions(+), 22 deletions(-)

-- 
1.7.9.5

