Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3AVNkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:40:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41323 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3AVNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:40:21 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 0/4] pwm_backlight: Error fixes and update for DT support
Date: Tue, 22 Jan 2013 14:39:52 +0100
Message-ID: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small series will:
- Fix the case when the kernel is booted in non DT mode and the board file try
to use levels array to specify the brightness levels.
- Validate the dft_brightness in all cases not only in DT mode.
- Add support in case of DT boot to be able to use the whole range of PWM.

Currently boards in legacy mode uses the 'max_brightness' value to specify the
maximum steps the PWM can be configured. When these boards move to DT support
they can no longer do this, they have to use the levels array. If we want to
have the same range in both DT and non DT case we would need to add all the
numbers from 0 to max (which can be 256) to the 'brightness-levels' array.
With the new property we can simply allow the whole range to be configured.

Regards,
Peter
---
Peter Ujfalusi (4):
  pwm_backlight: Fix PWM levels support in non DT case
  pwm_backlight: Validate dft_brightness in main probe function
  pwm_backlight: Refactor the DT parsing code
  pwm_backlight: Add support for the whole range of the PWM in DT mode

 .../bindings/video/backlight/pwm-backlight.txt     | 12 +++++-
 drivers/video/backlight/pwm_bl.c                   | 49 ++++++++++++----------
 2 files changed, 38 insertions(+), 23 deletions(-)

-- 
1.8.1.1

