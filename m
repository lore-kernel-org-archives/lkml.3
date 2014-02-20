Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaBTQgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:36:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35620 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbaBTQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:36:14 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v3 0/2] regulator: core: Fix ops->enable/disable usage
Date: Thu, 20 Feb 2014 17:36:02 +0100
Message-Id: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches replace all ops->enable/disable by
_regulator_do_disable/enable function calls. These wrappers also handle gpio
regulators.

v3 adds a comment about the moved _notifier_call_chain() function calls and
removes a unused variable from the core driver in patch 2
(Replace direct ops->disable usage).

Regards,

Markus


Markus Pargmann (2):
  regulator: core: Replace direct ops->enable usage
  regulator: core: Replace direct ops->disable usage

 drivers/regulator/core.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

-- 
1.8.5.3

