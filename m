Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3GPJFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:05:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41312 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753677Ab3GPJF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:05:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Z7YAu7j8DaSOiUU3P5mT7
Subject: [PATCH 0/4] improved support for runtime muxing for pinctrl
To: linus.walleij@linaro.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Jul 2013 02:05:24 -0700
Message-ID: <20130716090310.5541.36777.stgit@localhost>
User-Agent: StGit/0.16-1-ga54b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As discussed earlier, the pinctrl support for changing some of the
consumer device pins during runtime needs some improvment.

Here are the patches to do that, I'll also post a minimal sample
patch as a reply to this thread on how to do the muxing for
runtime PM.

Regards,

Tony

---

Tony Lindgren (4):
      pinctrl: Remove duplicate code in pinctrl_pm_select_state functions
      pinctrl: Allow pinctrl to have multiple active states
      pinctrl: Add support for additional dynamic states
      drivers: Add pinctrl handling for dynamic pin states


 drivers/base/pinctrl.c                |   39 +++++
 drivers/pinctrl/core.c                |  250 ++++++++++++++++++++++++++++-----
 drivers/pinctrl/core.h                |   10 +
 include/linux/pinctrl/consumer.h      |   46 ++++++
 include/linux/pinctrl/devinfo.h       |    4 +
 include/linux/pinctrl/pinctrl-state.h |   15 ++
 6 files changed, 321 insertions(+), 43 deletions(-)

-- 
Signature
