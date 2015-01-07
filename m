Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbbAGTml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:42:41 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:25392 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbbAGTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:42:39 -0500
X-IronPort-AV: E=Sophos;i="5.07,716,1413270000"; 
   d="scan'208";a="54210242"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        "Jonathan Richardson" <jonathar@broadcom.com>
Subject: [PATCH v5 0/2] Fix bugs in kona pwm driver and pwm core
Date: Wed, 7 Jan 2015 11:42:49 -0800
Message-ID: <1420659771-31401-1-git-send-email-jonathar@broadcom.com>
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

Changes from v4:
  - Rebased to Tim Kryger's patch that adds support in pwm core to add driver 
    with inversed polarity.   
  - Removed patch 2 that resolved difference between hardware default polarity
    and pwm framework default polarity. The default polarity is set properly now
    when the pwm driver is registered with the pwm framework.

Jonathan Richardson (2):
  pwm: kona: Fix incorrect config, disable, and polarity procedures
  pwm: core: Set enable state properly on failed call to enable

 drivers/pwm/core.c         |   10 ++++--
 drivers/pwm/pwm-bcm-kona.c |   75 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 68 insertions(+), 17 deletions(-)

-- 
1.7.9.5

